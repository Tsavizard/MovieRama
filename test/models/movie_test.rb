require "test_helper"

class MovieTest < ActiveSupport::TestCase
  test "is valid" do
    movie = Movie.new({ title: "The Shawshank redemption",  description: "A banker is framed for the murder of his wife", user: users(:one) })
    assert movie.valid?
  end
  test "must have a title" do
    movie = Movie.new({ title: "",  description: "A banker is framed for the murder of his wife", user: users(:one) })
    refute movie.valid?
  end

  test "title must not exceed 50 characters length" do
    excessive_string = (0...50).map { ("a".."z").to_a[rand(26)] }.join
    movie = Movie.new({ title: "The Shawshank redemption " + excessive_string,  description: "A banker is framed for the murder of his wife", user: users(:one) })
    refute movie.valid?
  end

  test "must have a description" do
    movie = Movie.new({ title: "The Shawshank redemption", description: "", user: users(:one) })
    refute movie.valid?

    movie2 = Movie.new({ title: "The Shawshank redemption", description: nil, user: users(:one) })
    refute movie2.valid?
  end

  test "description must not exceed 200 characters length" do
    excessive_string = (0...200).map { ("a".."z").to_a[rand(26)] }.join
    movie = Movie.new({ title: "The Shawshank redemption",  description: "A banker is framed for the murder of his wife " + excessive_string, user: users(:one) })
    refute movie.valid?
  end

  test "has many likes" do
    movie = movies(:one)
    assert movie.likes.size == 0
  end

  test "has many dislikes" do
    movie = movies(:one)
    assert movie.dislikes.size == 1
  end
end
