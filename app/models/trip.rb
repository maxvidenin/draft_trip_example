class Trip < ActiveRecord::Base
  belongs_to :user
  has_many :media, as: :mediable

  has_many :trip_payments
  has_many :payments, through: :trip_payments

  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }


  amoeba do
    enable
  end
end
