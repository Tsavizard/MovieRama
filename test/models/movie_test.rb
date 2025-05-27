require "test_helper"

class MovieTest < ActiveSupport::TestCase
  test "is valid" do
    movie = Movie.new({ title: "The Shawshank redemption",  description: "A banker is framed for the murder of his wife", user: users(:one) })
    assert movie.valid?
  end
  test "must have a title" do
    movie = Movie.new({ title: "",  description: "A banker is framed for the murder of his wife", user: users(:one) })
    assert movie.invalid?
  end

  test "title must not exceed 50 characters length" do
    excessive_string = (0...50).map { ("a".."z").to_a[rand(26)] }.join
    movie = Movie.new({ title: "The Shawshank redemption " + excessive_string,  description: "A banker is framed for the murder of his wife", user: users(:one) })
    assert movie.invalid?
  end

  test "must have a description" do
    movie = Movie.new({ title: "The Shawshank redemption", description: "", user: users(:one) })
    assert movie.invalid?

    movie2 = Movie.new({ title: "The Shawshank redemption", description: nil, user: users(:one) })
    assert movie2.invalid?
  end

  test "description must not exceed 200 characters length" do
    excessive_string = (0...200).map { ("a".."z").to_a[rand(26)] }.join
    movie = Movie.new({ title: "The Shawshank redemption",  description: "A banker is framed for the murder of his wife " + excessive_string, user: users(:one) })
    assert movie.invalid?
  end
end
