require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new to show login page" do
    get login_url
    assert_response :success
  end

  test "should post create to login a user" do
    assert_difference -> { Session.count } do
      post session_url, params: { email_address: users(:one).email_address, password: "password" }
    end
  end

  test "should redirect to home after login" do
    post session_url, params: { email_address: users(:one).email_address, password: "password" }
    assert_redirected_to movies_url
  end

  test "should not login with invalid credentials" do
    assert_no_difference -> { Session.count } do
      post session_url, params: { email_address: users(:one).email_address, password: "wrongpassword" }
    end
    assert_redirected_to new_session_path
    assert_equal "Invalid credentials.", flash[:alert]
  end

  test "should get destroy to logout a user" do
    post session_url, params: { email_address: users(:one).email_address, password: "password" }
    assert_difference -> { Session.count }, -1 do
      delete session_url
    end
  end

  test "should redirect to login page after logout" do
    post session_url, params: { email_address: users(:one).email_address, password: "password" }
    delete session_url
    assert_redirected_to new_session_path
  end
end
