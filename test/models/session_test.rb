require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "is valid with a user" do
    user = User.create!(email_address: "alex@example.com", password: "12345678", password_confirmation: "12345678", username: "test-user")
    session = Session.new(user: user, ip_address: "192.168.1.1", user_agent: "Mozilla/5.0")

    assert session.valid?, "Session should be valid when user is present"
  end

  test "is invalid without a user" do
    session = Session.new(ip_address: "192.168.1.1", user_agent: "Mozilla/5.0")

    refute session.valid?, "Session should be invalid without a user"
    assert_includes session.errors[:user], "must exist"
  end

  test "can have nil ip_address and user_agent" do
    user = User.create!(email_address: "alex@example.com", password: "12345678", password_confirmation: "12345678", username: "test-user")
    session = Session.new(user: user)

    assert session.valid?, "Session should be valid even if ip_address and user_agent are nil"
  end
end
