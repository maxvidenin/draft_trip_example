class TripPayment < ActiveRecord::Base
  validates :trip_id, :title, :description, :type, presence: true
  belongs_to :trip
  belongs_to :payment
end
