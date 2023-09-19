class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_access, only: [:show, :edit, :update, :destroy]

  def index
    @rooms = Room.eager_load(latest_message: { user: :profile })
                                .where(owner_id: current_user.id)
                                .or(Room.where(user_id: current_user.id))
                                .order('messages.created_at DESC')
                                .page(params[:page]).per(10)
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
    begin
    @room = @pet.rooms.find_or_create_by!(user_id: current_user.id, owner_id: @pet.user_id)
    redirect_to room_path(@room)
    rescue => e
      flash[:error] = '問合せできませんでした。'
      redirect_back(fallback_location: root_path)
    end
  end
  
  def show
    @message = Message.new
    @all_message_exchanges = @room.messages.page(params[:page]).per(5)

    @recipient = @room.recipient(current_user)
  end

  private

  def set_room
    @room =  Room.find(params[:id])
  end

  def authorize_access
    return if [@room.user_id, @room.owner_id].include?(current_user.id)
    
    redirect_to root_path, alert: "このルームにアクセスする権限がありません。"
  end
end
