class CreateItineraries < ActiveRecord::Migration
  def change
    create_table :itineraries do |t|
      t.string :name
      t.string :string
      t.integer :trip_id

      t.timestamps null: false
    end
  end
end
