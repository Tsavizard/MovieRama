require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new to show login page" do
    get login_url
    assert_response :success
  end

  test "should post create to login a user" do
    assert_difference -> { Session.count } do
      login_user(users(:one))
    end
  end

  test "should redirect to home after login" do
    login_user(users(:one))
    assert_redirected_to movies_url
  end

  test "should not login with invalid credentials" do
    assert_no_difference -> { Session.count } do
      post login_url, params: { email_address: users(:one).email_address, password: "wrongpassword" }
    end
    assert_redirected_to login_url
    assert_equal "Invalid credentials.", flash[:alert]
  end

  test "should destroy the session on logout a user" do
    login_user(users(:one))
    assert_difference -> { Session.count }, -1 do
      delete logout_url
    end
  end

  test "should redirect to login page after logout" do
    login_user(users(:one))
    delete logout_url
    assert_redirected_to login_path
  end
end
