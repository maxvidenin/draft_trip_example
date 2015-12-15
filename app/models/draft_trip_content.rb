class DraftTripContent < TripContent
  validates :trip_id, :title, :description, :type, presence: true
  belongs_to :trip
  has_many :media, as: :mediable, dependent: :destroy
  has_many :itineraries, foreign_key: 'trip_content_id', dependent: :destroy
end