class AddDurationToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :duration, :string
  end
end
