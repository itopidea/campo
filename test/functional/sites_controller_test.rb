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
end
