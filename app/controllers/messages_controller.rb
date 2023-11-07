class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]
  before_action :set_user

  def create
    @message = current_user.messages.create(message_params_on_create)
    
    # 送信先（受取先id)を取得する、受取先id とmessage.idをredisに保存する
    # 送信者はuserまたはownerである。

    room = Room.find(params[:room_id])
    receiver_id = (room.user_id == current_user.id) ? room.owner_id : room.user_id
    $redis.sadd("user:#{receiver_id}:unread_messages_in_rooms", room.id)
    redirect_to request.referer
  end

  def edit; end

  def update
    if @message.update(message_params_on_update)
      redirect_to room_path(@message.room_id) , notice: 'メッセージが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    if @message.destroy
      redirect_to room_path(@message.room_id) , notice: 'メッセージが削除されました。'
    else
      redirect_to room_path(@message.room_id) , alert: 'メッセージ削除に失敗しました。'
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params_on_update
    params.require(:message).permit(:body)
  end

  def message_params_on_create
    params.require(:message).permit(:body).merge(room_id: params[:room_id])
  end

  def check_owner
    return if @message.user == current_user
    redirect_to room_path(@message.room_id), alert: '他のユーザーのメッセージを編集することはできません。'
  end

  def set_user
    @user = current_user
  end

end
