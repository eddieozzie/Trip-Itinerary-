class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :title
      t.string :url
      t.decimal :yelp_rating
      t.string :city
      t.string :description

      t.timestamps
    end
  end
end
