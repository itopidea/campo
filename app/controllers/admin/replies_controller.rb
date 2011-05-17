class Admin::RepliesController < Admin::BaseController
  def index
    @replies = Reply.desc(:created_at).paginate :per_page => 20, :page => params[:page]
  end

  def show
    @reply = Reply.find params[:id]
  end

  def destroy
    @reply = Reply.find params[:id]
    @reply.destroy
    redirect_to :action => :index
  end
end
