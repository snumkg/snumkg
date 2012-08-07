#encoding: utf-8
class MessagesController < ApplicationController
  layout 'message'
  before_filter :check_signin

  def index
    if params[:type] == "receive"
      @messages = current_user.receive_messages
    else
      @messages = current_user.send_messages
    end
  end

  def show
    @message = Message.find(params[:id])
    @message.update_attribute(:read, true)
  end

  def new
    @message = Message.new
  end

  def destroy
    @message = Message.find(params[:id])

    if current_user == @message.sender && @message.read
      flash[:error] = "상대방이 읽은 쪽지는 삭제할 수 없습니다."
    else
      @message.destroy
      redirect_to messages_path(type: "receive")
    end
  end
end
