class PeopleController < ApplicationController
  respond_to :html, :rss, :only => [:topics]
  before_filter :layout_config

  def show
    @person = User.first :conditions => {:username => /^#{params[:username]}$/i}
    raise Mongoid::Errors::DocumentNotFound.new(User, params[:username]) if @person.nil?
    unless @person.banned?
      set_page_title @person.profile.name
      @topics = @person.topics.desc(:created_at).limit(10)
    end
  end

  def topics
    @person = User.first :conditions => {:username => /^#{params[:username]}$/i}
    raise Mongoid::Errors::DocumentNotFound.new(User, params[:username]) if @person.nil?
    unless @person.banned?
      set_page_title @person.profile.name
      @topics = @person.topics.desc(:created_at).paginate(:per_page => 20, :page => params[:page])
    else
      @topics = []
    end

    respond_with(@topics) do |format|
      format.html
      format.rss do
        @channel_link = person_url(:username => @person.username)
        render 'topics/topics', :layout => false
      end
    end
  end

  protected

  def layout_config
    self.show_head_html = true
  end
end
