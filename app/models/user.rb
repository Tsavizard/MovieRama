class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :votes
  has_many :likes, -> { where(vote_type: :like) }, class_name: "Vote"
  has_many :dislikes, -> { where(vote_type: :dislike) }, class_name: "Vote"

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, format: URI::MailTo::EMAIL_REGEXP
  validates_associated :votes

  def like(movie)
    votes.create(movie: movie, vote_type: "like")
  end

  def dislike(movie)
    votes.create(movie: movie, vote_type: "dislike")
  end

  def likes?(movie)
    likes.where(movie: movie).limit(1).present?
  end

  def dislikes?(movie)
    dislikes.where(movie: movie).limit(1).present?
  end
end
