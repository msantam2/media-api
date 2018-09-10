class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.integer :release_year
      t.text :synopsis
      t.text :genres
      t.integer :media_type_id, default: Api::MediaType.find_by_name("movie").id

      t.timestamps
    end

    add_index :movies, :title, unique: true
    add_foreign_key :movies, :media_types
  end
end
