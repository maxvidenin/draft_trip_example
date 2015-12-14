class CreateTripPayments < ActiveRecord::Migration
  def change
    create_table :trip_payments do |t|
      t.integer :trip_id
      t.integer :payment_id

      t.timestamps null: false
    end
  end
end
