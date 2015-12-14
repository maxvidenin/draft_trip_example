class TripPayment < ActiveRecord::Base
  belongs_to :trip
  belongs_to :payment
end
