class MessagesController < ApplicationController

  def index
    @message = Message.new
    # @message = @group.messages.includes(:user)
  end

  def new
    @pet = Pet.find(params[:format])
  end

  def create
    @messagen = Message.new
  end


end
