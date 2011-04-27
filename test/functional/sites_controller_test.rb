require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  def setup
    @user = create_user
  end

  test 'user can open sites new page' do
    get :new
    assert_redirected_to login_url

    login_as @user
    get :new
    assert_response :success, @response.body
  end

  test 'user can create site, but waiting approve' do
    post :create, :site => {:urlname => 'urlname', :name => 'name'}
    assert_redirected_to login_url
    
    login_as @user
    post :create, :site => {:urlname => 'urlname', :name => 'name'}
    assert_redirected_to own_sites_url
  end

  test 'user can read he owns sites' do
    get :own
    assert_redirected_to login_url
    
    login_as @user
    get :own
    assert_response :success, @response.body
  end
end
