class Movie::Vote < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :movie, uniqueness: { scope: :user, message: "can not vote more than once for a specific movie" }
  validates :vote_type, inclusion: { in: %w[like dislike] }
  validate :validate_not_own_submission

  def validate_not_own_submission
    errors.add :user, "User can not vote for movies they have submitted themselves" if user.has_submitted?(movie)
  end
end
