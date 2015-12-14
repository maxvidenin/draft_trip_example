class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :image_name
      t.string :mediable_type
      t.integer :mediable_id

      t.timestamps null: false
    end
  end
end
