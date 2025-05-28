class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :votes

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, format: URI::MailTo::EMAIL_REGEXP
  validates_associated :votes

  def like(movie)
    votes.create(movie: movie, vote_type: "like")
  end

  def dislike(movie)
    votes.create(movie: movie, vote_type: "dislike")
  end
end
