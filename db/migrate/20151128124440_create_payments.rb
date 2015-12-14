class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :transaction_id

      t.timestamps null: false
    end
  end
end
