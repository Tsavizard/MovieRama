require "test_helper"

class VotesControllerTest < ActionDispatch::IntegrationTest
  test "should create vote" do
    login_user(users(:three))
    movie_without_votes = movies(:three)

    assert_difference -> { movie_without_votes.votes.count } do
      post movie_votes_url(movie_without_votes), params: { vote: { vote_type: "like" } }
    end

    assert_redirected_to movie_url(movie_without_votes)
    assert_equal "Vote was successfully created.", flash[:notice]
  end

  test "should update an existing vote" do
    login_user(users(:two))
    movie = movie_votes(:two).movie

    assert_no_difference -> { movie.votes.count } do
      patch movie_votes_url(movie), params: { vote: { vote_type: "like" } }
    end
    assert_redirected_to movie_url(movie)
    assert_equal "Vote was successfully updated.", flash[:notice]
    assert_equal movie_votes(:two).reload.vote_type, "like"
  end

  test "should not create vote without type" do
    login_user(users(:three))
    movie_without_votes = movies(:three)
    assert_no_difference -> { movie_without_votes.votes.count } do
      post movie_votes_url(movie_without_votes), params: { vote: { vote_type: nil } }
    end
    assert_redirected_to movie_url(movie_without_votes)
    assert_equal "Failed to create vote.", flash[:alert]
  end

  test "should not create vote with invalid type" do
    login_user(users(:three))
    movie_without_votes = movies(:three)
    assert_no_difference -> { movie_without_votes.votes.count } do
      post movie_votes_url(movie_without_votes), params: { vote: { vote_type: "invalid" } }
    end

    assert_redirected_to movie_url(movie_without_votes)
    assert_equal "Failed to create vote.", flash[:alert]
  end

  test "should destroy vote" do
    login_user(users(:two))
    movie = movies(:one)

    assert_difference -> { movie.votes.count }, -1 do
      delete movie_votes_url(movie)
    end

    assert_redirected_to movie_url(movie)
    assert_equal "Vote was successfully deleted.", flash[:notice]
  end
end
