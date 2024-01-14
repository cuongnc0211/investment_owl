require "test_helper"

class User::InvesmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_invesment = user_invesments(:one)
  end

  test "should get index" do
    get user_invesments_url
    assert_response :success
  end

  test "should get new" do
    get new_user_invesment_url
    assert_response :success
  end

  test "should create user_invesment" do
    assert_difference("User::Invesment.count") do
      post user_invesments_url, params: { user_invesment: {  } }
    end

    assert_redirected_to user_invesment_url(User::Invesment.last)
  end

  test "should show user_invesment" do
    get user_invesment_url(@user_invesment)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_invesment_url(@user_invesment)
    assert_response :success
  end

  test "should update user_invesment" do
    patch user_invesment_url(@user_invesment), params: { user_invesment: {  } }
    assert_redirected_to user_invesment_url(@user_invesment)
  end

  test "should destroy user_invesment" do
    assert_difference("User::Invesment.count", -1) do
      delete user_invesment_url(@user_invesment)
    end

    assert_redirected_to user_invesments_url
  end
end
