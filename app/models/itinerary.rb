class Itinerary < ActiveRecord::Base
  validates :trip_content_id, :name, :string, presence: true
  belongs_to :trip
end
