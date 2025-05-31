class Movie < ApplicationRecord
  belongs_to :user
  has_many :votes, class_name: "Vote", dependent: :destroy
  has_many :likes, -> { where(vote_type: :like) }, class_name: "Vote"
  has_many :dislikes, -> { where(vote_type: :dislike) }, class_name: "Vote"

  validates_associated :votes

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: :true, length: { maximum: 200 }
end
