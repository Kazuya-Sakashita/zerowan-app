class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update]

  def create
    @message = current_user.messages.create(message_params_on_create)
    redirect_to request.referer
  end

  def edit
  end

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
      redirect_to room_path(@message.room_id) , alert: 'メッセージが削除に失敗しました。'
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

end
