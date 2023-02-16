class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @message = Message.new
  end

  def create
    @pet = Pet.find(params[:pet_id])
    @room = @pet.rooms.find_by(user_id: current_user.id, pet_id: @pet.id, owner_id: @pet.user_id)
    @message = current_user.messages.create(message_params)
    redirect_to request.referer
  end

  private

  def message_params
    params.require(:message).permit(:body).merge(room_id: @room.id)
  end
end
