require "test_helper"

class User::GenresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_genres_index_url
    assert_response :success
  end

  test "should get edit" do
    get user_genres_edit_url
    assert_response :success
  end

  test "should get new" do
    get user_genres_new_url
    assert_response :success
  end
end
