class CreateUserVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :user_votes do |t|
      t.belongs_to :user, null: false, foreign_key: true, index: { unique: true, name: "unique_votes" }
      t.belongs_to :movie, null: false, foreign_key: true
      t.string :vote_type

      t.timestamps
    end
  end
end
