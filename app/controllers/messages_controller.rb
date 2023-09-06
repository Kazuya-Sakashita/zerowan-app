class MessagesController < ApplicationController
  before_action :authenticate_user!


  def create
    @message = current_user.messages.create(message_params)
    redirect_to request.referer
  end

  private

  def message_params
    params.require(:message).permit(:body).merge(room_id: params[:room_id])
  end

  def find_pet
    room = Room.find(params[:room_id])
    @pet = Pet.find(room.pet_id)
  end

end
