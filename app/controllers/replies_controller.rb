class RepliesController < ApplicationController
  before_filter :require_logined, :require_user_not_banned
  respond_to :js, :only => [:create]
  
  def new
    set_page_title I18n.t 'replies.new.new_reply'
    @topic = Topic.find params[:topic_id]
    if @topic.closed?
      render_422
    else
      @reply = Reply.new
      @reply.topic_id = @topic.id
    end
  end

  def create
    @topic = Topic.find params[:reply][:topic_id]
    if @topic.closed?
      render_422
    else
      @reply = @topic.replies.new params[:reply]
      @reply.user = current_user
      @reply.save
      respond_with @reply do |format|
        format.html do
          if @reply.valid?
            redirect_to topic_url(@topic, :anchor => @topic.last_anchor)
          else
            set_page_title I18n.t 'replies.new.new_reply'
            render :new, :topic_id => @topic.id
          end
        end
        format.js { render :layout => false }
      end
    end
  end

  def edit
    set_page_title I18n.t 'replies.edit.edit_reply'
    @reply = current_user.replies.find params[:id]
    @topic = @reply.topic
  end

  def update
    @reply = current_user.replies.find params[:id]
    @topic = @reply.topic
    if @reply.update_attributes params[:reply]
      redirect_to params[:return_to].blank? ? @topic : "#{params[:return_to]}##{@reply.id}"
    else
      set_page_title I18n.t 'replies.edit.edit_reply'
      render :edit
    end
  end
end
