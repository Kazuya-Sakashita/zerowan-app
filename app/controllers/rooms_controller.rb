class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_pet, only: [:show]
  before_action :user_identification, only: [:show]

  def index
    @rooms = Room.all
  end

  def show
    @message = Message.new
    @room = @pet.rooms.find_or_create_by(user_id: current_user.id, pet_id: @pet.id, owner_id: @pet.user_id)
    @all_message_exchanges = Message.where(room_id: @room.id).order(id: :desc)
  end

  private

  def find_pet
    @pet = Pet.find(params[:pet_id])
  end

  def user_identification
    redirect_to pet_path(@pet) if @pet.user_id == current_user.id
  end
end
