class CreateUserVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :movie_votes do |t|
      t.belongs_to :user, null: true, foreign_key: true
      t.belongs_to :movie, null: false, foreign_key: true
      t.string :vote_type

      t.timestamps
      t.index [ :user_id, :movie_id ], unique: true, name: 'index_movie_votes_on_user_and_movie'
    end
  end
end
