class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @message = Message.new
    # @message = @group.messages.includes(:user)
  end

  def new
    @pet = Pet.find(params[:pet_id])
    @message = Message.new
    unless @pet.user_id == current_user.id
      if @room = Room.exists?(user_id: current_user.id, pet_id: @pet.id, owner_id: @pet.user_id)
        @room = Room.find_by(user_id: current_user.id, pet_id: @pet.id, owner_id: @pet.user_id)
      else
        @room = Room.create(user_id: current_user.id, pet_id: @pet.id, owner_id: @pet.user_id)
      end
      @all_message_exchanges = Message.where(room_id: @room.id).order(id: "DESC")
    end
  end

  def create
    @pet = Pet.find(params[:pet_id])
    @room = Room.find_by(user_id: current_user.id, pet_id: @pet.id, owner_id: @pet.user_id)
    @message = current_user.messages.create(message_params)
    redirect_to request.referer
  end

  private

  def message_params
    params.require(:message).permit(:body).merge(room_id: @room.id)
  end
end
