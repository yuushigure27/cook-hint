require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get inedx" do
    get admin_users_inedx_url
    assert_response :success
  end

  test "should get edit" do
    get admin_users_edit_url
    assert_response :success
  end

  test "should get show" do
    get admin_users_show_url
    assert_response :success
  end
end
