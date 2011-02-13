class TopicsController < ApplicationController
  def index
    @topics = Topic.skip(params[:skip]).limit(20)
  end

  def show
    @topic = Topic.find params[:id]
    @replies = @topic.replies.skip(params[:skip]).limit(20)
  end
end