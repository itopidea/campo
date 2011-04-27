class SitesController < ApplicationController
  before_filter :require_logined, :except => :index

  def new
    @site = Site.new
  end
end
