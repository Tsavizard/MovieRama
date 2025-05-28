require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "has email_address, password, password_confirmation and password_digest" do
    user = User.new({ email_address: "alex@example.com", password: "123456", password_confirmation: "123456" })
    assert user.email_address == "alex@example.com"
    assert user.password_digest.present?
    assert user.password == "123456"
    assert user.password_confirmation == "123456"
    assert user.valid?
  end

  test "normalizes email_address by stripping and downcasing" do
    user = User.create!(
      email_address: "  Alex@Example.COM  ",
      password: "123456",
      password_confirmation: "123456"
    )
    assert_equal "alex@example.com", user.email_address
  end

  test "validates email_address format" do
    user = User.new(
      email_address: "invalid-email",
      password: "123456",
      password_confirmation: "123456"
    )
    refute user.valid?
    assert_includes user.errors[:email_address], "is invalid"
  end

  test "like method creates a like vote" do
    user = User.create!(email_address: "alex@example.com", password: "123456", password_confirmation: "123456")
    movie = Movie.create!(title: "Inception")

    assert_difference -> { user.votes.count } do
      user.like(movie)
    end

    assert_equal "like", user.votes.last.vote_type
    assert_equal movie, user.votes.last.movie
  end

  test "dislike method creates a dislike vote" do
    user = User.create!(email_address: "alex@example.com", password: "123456", password_confirmation: "123456")
    movie = Movie.create!(title: "Inception")

    assert_difference -> { user.votes.count } do
      user.dislike(movie)
    end

    assert_equal "dislike", user.votes.last.vote_type
    assert_equal movie, user.votes.last.movie
  end

  test "sessions are destroyed with user" do
    user = User.create!(email_address: "alex@example.com", password: "123456", password_confirmation: "123456")
    user.sessions.create!(token: "abc123")

    assert_difference -> { Session.count }, -1 do
      user.destroy
    end
  end


  test "votes are not destroyed when user is destroyed" do
    user = User.create!(email_address: "alex@example.com", password: "123456", password_confirmation: "123456")
    movie = Movie.create!(title: "Inception")
    user.like(movie)

    assert_no_difference -> { Vote.count } do
      user.destroy
    end
  end
end
