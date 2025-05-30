require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should create user" do
    assert_difference -> { User.count } do
        post users_url, params: { user: { email_address: "assa@sada.com", password: "password", password_confirmation: "password", username: "testuser" } }
    end
    assert_redirected_to root_url
  end

  test "should login the created user and redirect to home" do
    assert_difference -> { Session.count } do
        post users_url, params: { user: { email_address: "assa@sada.com", password: "password", password_confirmation: "password", username: "testuser" } }
    end
    assert_redirected_to root_url
  end

  test "should not create user with invalid data" do
    assert_no_difference -> { User.count } do
      post users_url, params: { user: { email_address: "invalid-email", password: "123", password_confirmation: "123", username: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user with mismatched passwords" do
    assert_no_difference -> { User.count } do
      post users_url, params: { user: { email_address: "invalid-email", password: "1234", password_confirmation: "2344", username: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user with missing email" do
    assert_no_difference -> { User.count } do
      post users_url, params: { user: { password: "password", password_confirmation: "password", username: "testuser" } }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user with existing email" do
    existing_user = users(:one)
    assert_no_difference -> { User.count } do
      post users_url, params: { user: { email_address: existing_user.email_address, password: "password", password_confirmation: "password", username: "newuser" } }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user with existing username" do
    existing_user = users(:one)
    assert_no_difference -> { User.count } do
      post users_url, params: { user: { email_address: "assa@sada.com", password: "password", password_confirmation: "password", username: existing_user.username } }
    end
    assert_response :unprocessable_entity
  end
end
