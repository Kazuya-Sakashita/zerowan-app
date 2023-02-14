class RoomsController < ApplicationController
  before_action :authenticate_user!

  def show
    @pet = Pet.find(params[:pet_id])
    @message = Message.new

    unless @pet.user_id == current_user.id
      @room = @pet.rooms.find_or_create_by(user_id: current_user.id, pet_id: @pet.id, owner_id: @pet.user_id)
    end
      @all_message_exchanges = Message.where(room_id: @room.id).order(id: :desc)
  end
end
