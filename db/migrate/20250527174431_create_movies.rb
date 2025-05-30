class CreateMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :description
      t.belongs_to :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
