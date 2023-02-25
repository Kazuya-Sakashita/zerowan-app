class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_pet
  before_action :room_identification, only: [:create]

  def index
    @messages = Message.all
  end

  def create
    @room = @pet.rooms.find_by(user_id: current_user.id, pet_id: @pet.id, owner_id: @pet.user_id)
    room_identification && return
    @message = current_user.messages.create(message_params)
    redirect_to request.referer
  end

  private

  def message_params
    params.require(:message).permit(:body).merge(room_id: @room.id)
  end

  def find_pet
    @pet = Pet.find(params[:pet_id])
  end

  def room_identification
    redirect_to pet_path(@pet) if @room == nil?
  end
end
