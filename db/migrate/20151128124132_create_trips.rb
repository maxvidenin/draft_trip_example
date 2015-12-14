class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :title
      t.string :string
      t.integer :user_id
      t.boolean :published, default: false

      t.timestamps null: false
    end
  end
end
