class AddTravelTimeToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :travelTime, :decimal
  end
end
