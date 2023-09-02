class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_pet, only: [:create]
  before_action :find_room, only: [:create]
  before_action :room_identification, only: [:create]

  def index
    # ログインユーザーが参加しているルームを取得
    joined_rooms = current_user.rooms
    
    # ログインユーザーがオーナーであるルームを取得
    owned_rooms = Room.where(owner_id: current_user.id)

    # 両方のルームに存在する可能性があるので、重複を削除
    all_rooms = joined_rooms | owned_rooms

    # 最新メッセージをそれぞれ取得
    joined_latest_messages = joined_rooms.map(&:latest_message).compact.sort_by(&:created_at).reverse
    owned_latest_messages = owned_rooms.map(&:latest_message).compact.sort_by(&:created_at).reverse


    # コンテキストに応じて変数をセット
    if owned_rooms.exists?
      @rooms = owned_rooms
      @latest_messages = owned_latest_messages
    else
      @rooms = joined_rooms
      @latest_messages = joined_latest_messages
    end

   end

  def create
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

  def find_room
    @room = @pet.rooms.find_by(user_id: current_user.id, pet_id: @pet.id, owner_id: @pet.user_id)
  end

  def room_identification
    redirect_to pet_path(@pet) if @room.nil?
  end
end
