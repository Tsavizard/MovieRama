require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "has email_address, password, password_confirmation and password_digest and username" do
    user = User.new({ email_address: "alex@example.com", password: "12345678", password_confirmation: "12345678", username: "alex" })
    assert user.email_address == "alex@example.com"
    assert user.password_digest.present?
    assert user.password == "12345678"
    assert user.password_confirmation == "12345678"
    assert user.username == "alex"
    assert user.valid?
  end

  test "normalizes email_address by stripping and downcasing" do
    user = User.create(
      email_address: "  Alex@Example.COM  ",
      password: "12345678",
      password_confirmation: "12345678",
      username: "alex"
    )
    assert_equal "alex@example.com", user.email_address
  end

  test "validates email_address format" do
    user = User.new(
      email_address: "invalid-email",
      password: "12345678",
      password_confirmation: "12345678",
      username: "alex"
    )
    refute user.valid?
    assert_includes user.errors[:email_address], "is invalid"
  end

  test "validates email_address uniqueness" do
    user = User.new(email_address: users(:one).email_address, password: "12345678", password_confirmation: "12345678", username: "alex2")
    refute user.valid?
  end

  test "validates email_address length" do
    user = User.new(
      email_address: "a" * 101 + "@example.com",
      password: "12345678",
      password_confirmation: "12345678",
      username: "alex"
    )
    refute user.valid?
  end

  test "validates password presence" do
    user = User.new(
      email_address: "alex@example.com",
      password_confirmation: "12345678",
      username: "alex")
    refute user.valid?
  end

  test "validates password length is at least 8 characters" do
    user = User.new(
      email_address: "alex@example.com",
      password: "123",
      password_confirmation: "12345678",
      username: "alex")
    refute user.valid?
  end

  test "validates password_confirmation presence" do
    user = User.new(
      email_address: "alex@example.com",
      password: "12345678",
      password_confirmation: "",
      username: "alex")
    refute user.valid?
  end

  test "validates password_confirmation matches password" do
    user = User.new(
      email_address: "alex@example.com",
      password: "12345678",
      password_confirmation: "24",
      username: "alex")
    refute user.valid?
  end

  test "validates username presence" do
    user = User.new(
      email_address: "alex@example.com",
      password: "12345678",
      password_confirmation: "12345678",
      username: "")
    refute user.valid?
  end

  test "validates username uniqueness" do
    user = User.new(
      email_address: "alex@example.com",
      password: "12345678",
      password_confirmation: "12345678",
      username: users(:one).username)
    refute user.valid?
  end

  test "validates username length is between 3 and 50 characters" do
    user = User.new(
      email_address: "alex@example.com",
      password: "12345678",
      password_confirmation: "12345678",
      username: "a" * 51)
    refute user.valid?

    user2 = User.new(
      email_address: "alex@example.com",
      password: "12345678",
      password_confirmation: "12345678",
      username: "a" * 2)
    refute user2.valid?
  end

  test "like method creates a like vote if not already voted" do
    user = users(:three)
    movie = movies(:three)

    assert user.votes.find_by(movie: movie).nil?
    assert_difference -> { user.votes.count } do
      user.like(movie)
    end

    assert_equal "like", user.votes.find_by(movie: movie).vote_type
    assert user.votes.find_by(movie: movie).present?
  end

  test "like method changes a dislike vote to a like vote" do
    user = users(:two)
    movie = movies(:one)

    assert_no_difference -> { user.votes.count } do
      user.like(movie)
    end

    assert_equal "like", user.votes.find_by(movie: movie).vote_type
    assert user.votes.find_by(movie: movie).present?
  end

  test "like method does nothing to a 'like' vote" do
    user = users(:one)
    movie = movies(:two)

    assert_no_difference -> { user.votes.count } do
      user.like(movie)
    end

    assert_equal "like", user.votes.find_by(movie: movie).vote_type
  end

  test "like method does not create a like vote if the user was the one who submitted the movie" do
    user = users(:one)
    movie = movies(:one)

    assert_no_difference -> { user.votes.count } do
      user.like(movie)
    end

    assert user.votes.find_by(movie: movie).nil?
  end

  test "dislike method creates a dislike vote if not already voted" do
    user = users(:three)
    movie = movies(:three)

    assert user.votes.find_by(movie: movie).nil?
    assert_difference -> { user.votes.count } do
      user.dislike(movie)
    end

    assert_equal "dislike", user.votes.find_by(movie: movie).vote_type
    assert user.votes.find_by(movie: movie).present?
  end

  test "dislike method changes a like vote to a dislike vote" do
    user = users(:one)
    movie = movies(:two)

    assert_no_difference -> { user.votes.count } do
      user.dislike(movie)
    end

    assert_equal "dislike", user.votes.find_by(movie: movie).vote_type
    assert user.votes.find_by(movie: movie).present?
  end

  test "dislike method does not create a dislike vote if the user was the one who submitted the movie" do
    user = users(:one)
    movie = movies(:one)

    assert_no_difference -> { user.votes.count } do
      user.dislike(movie)
    end

    assert user.votes.find_by(movie: movie).nil?
  end

  test "dislike method does nothing to a 'dislike' vote" do
    user = users(:two)
    movie = movies(:one)

    assert_no_difference -> { user.votes.count } do
      user.dislike(movie)
    end

    assert_equal "dislike", user.votes.find_by(movie: movie).vote_type
  end

  test "likes? returns true if user has liked the movie" do
    user = users(:three)
    movie = movies(:three)
    user.like(movie)
    assert user.likes?(movie)
    assert user.votes.find_by(movie: movie).present?
  end

  test "likes? returns false if user has not liked the movie" do
    user = users(:three)
    movie = movies(:three)
    assert_not user.likes?(movie)
    assert user.votes.find_by(movie: movie).nil?
  end

  test "dislikes? returns true if user has disliked the movie" do
    user = users(:three)
    movie = movies(:three)
    user.dislike(movie)
    assert user.dislikes?(movie)
    assert user.votes.find_by(movie: movie).present?
  end

  test "dislikes? returns false if user has not disliked the movie" do
    user = users(:three)
    movie = movies(:three)
    assert_not user.dislikes?(movie)
    assert user.votes.find_by(movie: movie).nil?
  end

  test "get_vote returns the user's vote for a movie" do
    user = users(:three)
    movie = movies(:three)
    user.like(movie)
    vote = user.get_vote(movie)
    assert vote.present?
    assert_equal "like", vote.vote_type
  end

  test "get_vote returns nil if user has not voted for the movie" do
    user = users(:three)
    movie = movies(:three)
    vote = user.get_vote(movie)
    assert vote.nil?
  end

  test "movies are not destroyed when user is destroyed" do
    user = users(:three)
    user.movies.create!(title: "Test Movie", description: "Test Description")

    assert_no_difference -> { Movie.count } do
      user.destroy
    end
  end

  test "votes are not destroyed when user is destroyed" do
    user = users(:three)
    user.like(movies(:three))

    assert_no_difference -> { Movie::Vote.count } do
      user.destroy
    end
  end

  test "sessions are destroyed with user" do
    user = users(:one)
    user.sessions.create()

    assert_difference -> { Session.count }, -1 do
      user.destroy
    end
  end
end
