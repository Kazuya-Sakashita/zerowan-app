class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @message = Message.new
    # @message = @group.messages.includes(:user)
  end

  def new
    @pet = Pet.find(params[:pet_id])
    @message = Message.new
    @customer_entry = Entry.where(user_id: current_user.id)
    @pet_entry = Entry.where(pet_id: @pet.id)
    @owner_entry = Entry.where(user_id: @pet.user_id)
    unless @pet.user_id == current_user.id
      @customer_entry.each do |current|
        @pet_entry.each do |pet|
          @owner_entry.each do |owner|
            if current.room_id == owner.room_id && owner.room_id == pet.room_id
              @is_room = true
              @room_id = current.room_id
            end
          end
        end
      end
      unless @is_room
        @room = Room.create(user_id: current_user.id)
        @customer_entry = Entry.create(room_id: @room.id, user_id: current_user.id, pet_id: @pet.id)
        @owner_entry = Entry.create(room_id: @room.id, user_id: @pet.user_id, pet_id: @pet.id)
      end
    end
    @all_message_exchanges = Message.where(room_id: @room_id).order(id: "DESC")
  end

  def create
    # TODO room_id渡す部分など、もう少し工夫が必要
    @pet = Pet.find(params[:pet_id])
    @entry = current_user.entries.where(pet_id: @pet.id)
    @room_id = @entry[0].room_id
    @message = current_user.messages.create(message_params)
    redirect_to request.referer
  end

  def message_params
    params.require(:message).permit(:body).merge(room_id: @room_id)
  end
end
