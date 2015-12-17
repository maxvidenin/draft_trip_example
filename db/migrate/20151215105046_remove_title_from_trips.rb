class RemoveTitleFromTrips < ActiveRecord::Migration
  def change
    remove_column :trips, :title, :string
    remove_column :trips, :string, :string
  end
end
