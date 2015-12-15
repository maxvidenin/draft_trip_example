class RemoveTripIdFromItineraries < ActiveRecord::Migration
  def change
    remove_reference :itineraries, :trip, index: true, foreign_key: {on_delete: :cascade}
  end
end
