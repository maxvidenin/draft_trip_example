class Payment < ActiveRecord::Base
  has_many :trip_payments
  has_many :trips, through: :trip_payments
end
