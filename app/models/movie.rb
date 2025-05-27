class Movie < ApplicationRecord
  belongs_to :user
  has_many :votes, class_name: "User::Vote"

  validates_associated :votes

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: :true, length: { maximum: 200 }
end
