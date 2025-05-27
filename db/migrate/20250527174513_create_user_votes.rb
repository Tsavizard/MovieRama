class CreateUserVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :user_votes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :movie, null: false, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
