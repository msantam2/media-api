class CreateShows < ActiveRecord::Migration[5.2]
  def change
    create_table :shows do |t|
      t.string :title, null: false
      t.integer :release_year
      t.text :synopsis
      t.text :genres
      t.integer :media_type_id, default: Api::MediaType.find_by_name("show").id

      t.timestamps
    end

    add_index :shows, :title, unique: true
    add_foreign_key :shows, :media_types
  end
end
