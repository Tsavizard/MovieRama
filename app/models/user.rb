class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :movies, dependent: :nullify
  has_many :votes, dependent: :nullify
  has_many :likes, -> { where(vote_type: :like) }, class_name: "Vote"
  has_many :dislikes, -> { where(vote_type: :dislike) }, class_name: "Vote"

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, format: URI::MailTo::EMAIL_REGEXP
  validates :email_address, uniqueness: true
  validates :email_address, length: { maximum: 100 }

  validates :password, presence: true, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  validates :password_confirmation, presence: true, if: -> { new_record? || !password.nil? } do |record|
    record.errors.add(:password_confirmation, "does not match password") unless record.password == record.password_confirmation
  end

  validates :password_digest, presence: true

  validates :username, presence: true, uniqueness: true
  validates :username, length: { minimum: 3, maximum: 50 }

  validates_associated :votes

  def like(movie)
    return if movie.user == self

    vote = votes.find_by(movie: movie)
    if !vote
      votes.create(movie: movie, vote_type: "like")
      return
    end

    vote.update(vote_type: "like") if vote.vote_type == "dislike"
  end

  def dislike(movie)
    return if movie.user == self

    vote = votes.find_by(movie: movie)
    if !vote
      votes.create(movie: movie, vote_type: "dislike")
      return
    end

    vote.update(vote_type: "dislike") if vote.vote_type == "like"
  end

  def likes?(movie)
    likes.find_by(movie: movie).present?
  end

  def dislikes?(movie)
    dislikes.find_by(movie: movie).present?
  end
end
