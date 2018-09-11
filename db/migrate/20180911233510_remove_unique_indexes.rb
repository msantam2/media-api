class RemoveUniqueIndexes < ActiveRecord::Migration[5.2]
  def change
    remove_index :movies, :title
    remove_index :shows, :title
  end
end
