class SitesController < ApplicationController
  before_filter :require_logined, :except => :index

  def new
    @site = Site.new
  end

  def create
    @site = current_user.own_sites.build params[:site]
    if @site.save
      flash[:notice] = I18n.t('sites.create.waiting_approve')
      redirect_to own_sites_url
    else
      render :new
    end
  end

  def own
    @sites = current_user.own_sites
  end
end
