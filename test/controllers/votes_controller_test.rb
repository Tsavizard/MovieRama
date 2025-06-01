require "test_helper"

class VotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie_without_votes = movies(:three)
    post session_url, params: { email_address: users(:one).email_address, password: "password" }
  end

  test "should create vote" do
    assert_difference -> { @movie_without_votes.votes.count } do
      post movie_votes_url(@movie_without_votes), params: { vote: { vote_type: "like" } }
    end

    assert_redirected_to movie_url(@movie_without_votes)
    assert_equal "Vote was successfully created.", flash[:notice]
  end

  test "should update an exsting vote" do
    movie = movie_votes(:one).movie
    assert_no_difference -> { movie.votes.count } do
      post movie_votes_url(movie), params: { vote: { vote_type: "dislike" } }
    end
    assert_redirected_to movie_url(movie)
    assert_equal "Vote was successfully created.", flash[:notice]
    assert_equal movie_votes(:one).vote_type, "dislike"
  end

  test "should not create vote without type" do
    assert_no_difference -> { @movie_without_votes.votes.count } do
      post movie_votes_url(@movie_without_votes), params: { vote: { vote_type: nil } }
    end
    assert_redirected_to movie_url(@movie_without_votes)
    assert_equal "Failed to create vote.", flash[:alert]
  end

  test "should not create vote with invalid type" do
    assert_no_difference -> { @movie_without_votes.votes.count } do
      post movie_votes_url(@movie_without_votes), params: { vote: { vote_type: "invalid" } }
    end

    assert_redirected_to movie_url(@movie_without_votes)
    assert_equal "Failed to create vote.", flash[:alert]
  end

  test "should destroy vote" do
    movie = movies(:two)

    assert_difference -> { movie.votes.count }, -1 do
      delete movie_vote_path(movie, movie.votes(:one).id)
    end

    assert_redirected_to movie_url(movie)
    assert_equal "Vote was successfully deleted.", flash[:notice]
  end
end
