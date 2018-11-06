class CreateElectricCars < ActiveRecord::Migration[5.2]
  def change
    create_table :electric_cars do |t|
      t.string :brand
      t.string :model
      t.integer :power
      t.integer :max_speed
      t.integer :battery_capacity
      t.integer :real_range
      t.integer :advertised_range
      t.integer :price
      t.string :uri

      t.timestamps
    end
  end
end
