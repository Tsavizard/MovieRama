require "test_helper"

class User::VoteTest < ActiveSupport::TestCase
  test "is valid" do
    vote = User::Vote.new({ movie: movies(:one), user: users(:three), vote_type: "like" })
    assert vote.valid?
  end

  test "user can not vote on their own submissions" do
    vote = User::Vote.new({ movie: movies(:one), user: users(:one), vote_type: "like" })
    assert vote.invalid?
  end

  test "user can not vote multiple time for the same movie" do
    # users(:one).votes.create({ movie: movies(:two) })
    duplicate_vote = users(:one).votes.create({ movie: movies(:two), vote_type: "like" })
    assert duplicate_vote.invalid?
    assert User::Vote.count == 2
  end

  test "can be a like or a dislike" do
    like = User::Vote.new({ movie: movies(:one), user: users(:three), vote_type: "like" })
    assert like.valid?

    dislike = User::Vote.new({ movie: movies(:one), user: users(:three), vote_type: "dislike" })
    assert dislike.valid?

    invalid_vote = User::Vote.new({ movie: movies(:one), user: users(:three), vote_type: "asdsada" })
    assert invalid_vote.invalid?
  end
end
