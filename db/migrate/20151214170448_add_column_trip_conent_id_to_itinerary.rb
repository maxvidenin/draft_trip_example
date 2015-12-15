class AddColumnTripConentIdToItinerary < ActiveRecord::Migration
  def change
    add_reference :itineraries, :trip_content, index: true, foreign_key: {on_cascade: :delete}
  end
end
