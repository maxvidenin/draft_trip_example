class CreateTripContents < ActiveRecord::Migration
  def change
    create_table :trip_contents do |t|
      t.references :trip, index: true, foreign_key: {on_delete: :cascade}
      t.string :title
      t.text :description
      t.string :type

      t.timestamps null: false
    end
  end
end
