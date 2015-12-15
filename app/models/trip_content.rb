class TripContent < ActiveRecord::Base
  validates :trip_id, :title, :description, :type, presence: true
  belongs_to :trip
  has_many :media, as: :mediable, dependent: :destroy
  has_many :itineraries, dependent: :destroy
end
