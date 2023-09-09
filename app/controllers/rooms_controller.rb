class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_access, only: [:show, :edit, :update, :destroy]

  def index
    # 現在のユーザーがオーナーであるルーム
    owned_rooms = Room.where(owner_id: current_user.id)

    # 現在のユーザーが参加しているルーム
    joined_rooms = Room.where(user_id: current_user.id)

    # 両方を合成
    all_rooms = owned_rooms | joined_rooms


    # 最新メッセージをそれぞれ取得
    @latest_messages = all_rooms.map(&:latest_message).compact.sort_by(&:created_at).reverse
  end

  def new
    # params[:format]を使用してPetテーブルから特定のペットを検索
    @pet = Pet.find(params[:format])

    # 以下の条件にマッチするRoomが存在するか確認し、なければ新しいRoomを作成
    @room = @pet.rooms.find_or_create_by(user_id: current_user.id, pet_id: @pet.id, owner_id: @pet.user_id)

    # Roomが既にデータベースに存在する（保存されている）場合とそうでない場合で処理を分ける
    if @room.persisted?
      # Roomが存在する場合、そのRoomの詳細ページ（show）にリダイレクト
      redirect_to room_path(@room)
    else
      # Roomが存在しない（作成に失敗した）場合、エラーメッセージをフラッシュに設定
      flash[:error] = '問合せできませんでした。'
    end

  end
  
  def show
    @pet = Pet.find(@room.pet_id)
    @message = Message.new
    @all_message_exchanges = @room.messages
    set_user_name #viewの宛名表示に使う
  end

  private

  def set_room
    @room =  Room.find(params[:id])
  end

  def set_user_name
    target_id = if current_user.id == @room.user_id
                  @room.owner_id
                else
                  @room.user_id
                end

    @user_name = User.find(target_id).profile.name
  end

  def authorize_access
    unless current_user.id == @room.user_id || current_user.id == @room.owner_id
      redirect_to root_path, alert: "このルームにアクセスする権限がありません。"
    end
  end
end
