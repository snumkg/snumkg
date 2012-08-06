class MessagesController < ApplicationController
  layout 'main'
  before_filter :check_signin

  def index
    @send_messages = current_user.send_messages
    @receive_messages = current_user.receive_messages
  end

  def show
    @message = Message.find(params[:id])
    @message.update_attribute(:read, true)
  end
end
