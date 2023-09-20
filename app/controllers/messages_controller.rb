class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:edit, :update]


  def create
    @message = current_user.messages.create(message_params_merge_room)
    redirect_to request.referer
  end

  def edit
  end

  def update
    if @message.update(message_params)
      redirect_to room_path(@message.room_id) , notice: 'メッセージが更新されました。'
    else
      render :edit
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:body)
  end

  def message_params_merge_room
    params.require(:message).permit(:body).merge(room_id: params[:room_id])
  end

end
