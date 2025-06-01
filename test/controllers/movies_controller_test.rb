require "test_helper"

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie = movies(:one)
    post session_url, params: { email_address: users(:one).email_address, password: "password" }
  end

  test "should get index" do
    get movies_url(format: :json)
    assert_response :success
    json = JSON.parse(@response.body)

    expected_movies = Movie.all.order(created_at: :desc)
    assert_equal expected_movies.map(&:id), json.map { |movie| movie["id"] }
  end

  test "should return movies sorted by like count descending" do
    get movies_url(format: :json), params: { sort: "likes" }
    assert_response :success
    json = JSON.parse(@response.body)

    expected_movies = [ movies(:two), movies(:three), movies(:one) ]
    assert_equal expected_movies.map(&:id), json.map { |movie| movie["id"] }
  end

  test "should return movies sorted by dislike count descending" do
    get movies_url(format: :json), params: { sort: "dislikes" }
    assert_response :success
    json = JSON.parse(@response.body)

    expected_movies = [ movies(:one), movies(:three), movies(:two) ]
    assert_equal expected_movies.map(&:id), json.map { |movie| movie["id"] }
  end

  test "should return movies sorted by creation date ascending" do
    get movies_url(format: :json), params: { sort: "date" }
    assert_response :success
    json = JSON.parse(@response.body)

    expected_movies = Movie.all
    assert_equal expected_movies.map(&:id), json.map { |movie| movie["id"] }
  end


  test "should return movies for a specific user" do
    get movies_url(format: :json), params: { user: users(:one).id }
    assert_response :success
    json = JSON.parse(@response.body)

    expected_movies = [ movies(:three), movies(:one) ]
    assert_equal expected_movies.map(&:id), json.map { |movie| movie["id"] }
  end

  test "should get new" do
    get new_movie_url
    assert_response :success
  end

  test "should create movie" do
    assert_difference -> { Movie.count } do
      post movies_url, params: { movie: { description: "movie for testing reasons", title: "some test movie", user_id: users(:one).id } }
    end

    assert_redirected_to movie_url(Movie.last)
  end

  test "should not create movie with invalid data" do
    assert_no_difference -> { Movie.count } do
      post movies_url, params: { movie: { description: "", title: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should show movie" do
    get movie_url(@movie)
    assert_response :success
  end

  test "should get edit" do
    get edit_movie_url(@movie)
    assert_response :success
  end

  test "should update movie" do
    patch movie_url(@movie), params: { movie: { description: @movie.description, title: @movie.title } }
    assert_redirected_to movie_url(@movie)
  end

  test "should fail if movie not found" do
    assert_no_difference -> { Movie.count } do
      patch movies_url(9), params: { movie: { description: "test movie description", title: "test movie" } }
    end
    assert_response :not_found
  end

  test "should not update movie with invalid data" do
    assert_no_difference -> { Movie.count } do
      patch movie_url(@movie), params: { movie: { description: "", title: ""  } }
    end
    assert_response :unprocessable_entity
  end

  test "should destroy movie" do
    assert_difference -> { Movie.count }, -1 do
      delete movie_url(@movie)
    end

    assert_redirected_to movies_url
  end
end
