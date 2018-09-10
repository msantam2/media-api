class CreateMediaTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :media_types do |t|
      t.string :name, null: false
    end

    Api::MediaType.create(name: "movie")
    Api::MediaType.create(name: "show")
  end
end
