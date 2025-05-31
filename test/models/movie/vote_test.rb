require "test_helper"

class Movie::VoteTest < ActiveSupport::TestCase
  test "is valid" do
    vote = Movie::Vote.new({ movie: movies(:one), user: users(:three), vote_type: "like" })
    assert vote.valid?
  end

  test "user can not vote on their own submissions" do
    vote = Movie::Vote.new({ movie: movies(:one), user: users(:one), vote_type: "like" })
    refute vote.valid?
  end

  test "user can not vote multiple time for the same movie" do
    # users(:one).votes.create({ movie: movies(:two) })
    duplicate_vote = users(:one).votes.create({ movie: movies(:two), vote_type: "like" })
    refute duplicate_vote.valid?
    assert Movie::Vote.count == 2
  end

  test "can be a like or a dislike" do
    like = Movie::Vote.new({ movie: movies(:one), user: users(:three), vote_type: "like" })
    assert like.valid?

    dislike = Movie::Vote.new({ movie: movies(:one), user: users(:three), vote_type: "dislike" })
    assert dislike.valid?

    invalid_vote = Movie::Vote.new({ movie: movies(:one), user: users(:three), vote_type: "asdsada" })
    refute invalid_vote.valid?
  end
end
