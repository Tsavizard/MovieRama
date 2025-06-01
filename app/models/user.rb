class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :movies, dependent: :nullify
  has_many :votes, dependent: :nullify, class_name: "Movie::Vote"
  has_many :likes, -> { where(vote_type: :like) }, class_name: "Movie::Vote"
  has_many :dislikes, -> { where(vote_type: :dislike) }, class_name: "Movie::Vote"

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, format: URI::MailTo::EMAIL_REGEXP
  validates :email_address, uniqueness: true
  validates :email_address, length: { maximum: 100 }

  validates :password, presence: true, length: { minimum: 8 }
  validates :password_confirmation, presence: true, comparison: { equal_to: :password }

  validates :password_digest, presence: true

  validates :username, presence: true, uniqueness: true
  validates :username, length: { minimum: 3, maximum: 50 }

  validates_associated :votes

  def like(movie)
    return if movie.user == self

    if vote = votes.find_by(movie: movie)
      vote.update(vote_type: "like") unless vote.vote_type == "like"
      vote
    else
      votes.create(movie: movie, vote_type: "like")
    end
  end

  def dislike(movie)
    return if movie.user == self

    if vote = votes.find_by(movie: movie)
      vote.update(vote_type: "dislike") unless vote.vote_type == "dislike"
      vote
    else
      votes.create(movie: movie, vote_type: "dislike")
    end
  end

  def likes?(movie)
    likes.find_by(movie: movie).present?
  end

  def dislikes?(movie)
    dislikes.find_by(movie: movie).present?
  end

  def get_vote(movie)
    votes.find_by(movie_id: movie.id)
  end

  def has_submitted?(movie)
    movies.exists?(movie.id)
  end
end
