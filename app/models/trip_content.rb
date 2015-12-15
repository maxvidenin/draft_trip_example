class TripContent < ActiveRecord::Base
  belongs_to :trip
  has_many :media, as: :mediable, dependent: :destroy
  has_many :itineraries, dependent: :destroy
end
