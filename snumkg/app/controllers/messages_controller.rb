#encoding: utf-8
class MessagesController < ApplicationController
  layout 'message'
  before_filter :check_signin

  def index
    if params[:type] == "receive"
      @messages = current_user.receive_messages.order("created_at desc")
    else
      @messages = current_user.send_messages.order("created_at desc")
    end
  end

  def show
    @message = Message.find(params[:id])
    
    # 쪽지를 받은 사람이 읽었을 때
    if @message.receiver == current_user
      @message.update_attribute(:read, true)
    end
  end

  def new
    @message = Message.new

    @receiver = User.find_by_id(params[:receiver_id])
  end

  def create
    @message = Message.new(params[:message])

    @message.save
    redirect_to messages_path(type: "receive")
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
