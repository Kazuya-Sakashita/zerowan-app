class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_access, only: [:show, :edit, :update, :destroy]

  def index
    all_rooms = Room.preload(:messages).where(owner_id: current_user.id).or(Room.where(user_id: current_user.id)) 

  # 最新メッセージをそれぞれ取得
    @latest_messages = all_rooms.map(&:latest_message).compact.sort_by(&:created_at).reverse
  end

  def new
    # params[:format]を使用してPetテーブルから特定のペットを検索
    @pet = Pet.find(params[:format])

    #user_id と owner_id が同一であった場合に弾く
    if current_user.id == @pet.user_id
      flash[:error] = '自分自身にメッセージはできません'
      redirect_back(fallback_location: root_path) # 保存失敗時も前のページにリダイレクト。
      return
    end

    # 以下の条件にマッチするRoomが存在するか確認し、なければ新しいRoomを作成
    @room = @pet.rooms.find_or_initialize_by(user_id: current_user.id, owner_id: @pet.user_id)

    # Roomが既にデータベースに存在する（保存されている）場合とそうでない場合で処理を分ける
    if @room.persisted? || @room.save
      # Roomが存在する場合、そのRoomの詳細ページ（show）にリダイレクト
      redirect_to room_path(@room)
    else
      # Roomが存在しない（作成に失敗した）場合、エラーメッセージをフラッシュに設定
      flash[:error] = '問合せできませんでした。'
      redirect_back(fallback_location: root_path) # 保存失敗時も前のページにリダイレクト。
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
    target_user = current_user == @room.user ? @room.owner : @room.user
    @user_name = target_user.profile.name
  end

  def authorize_access
    unless [@room.user_id, @room.owner_id].include?(current_user.id)
      redirect_to root_path, alert: "このルームにアクセスする権限がありません。"
    end
  end
end
