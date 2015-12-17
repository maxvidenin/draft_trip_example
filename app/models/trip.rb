class Trip < ActiveRecord::Base
  validates :user_id, presence: true
  belongs_to :user

  has_many :trip_payments
  has_many :payments, through: :trip_payments

  has_one :published_trip_content, dependent: :destroy
  has_one :draft_trip_content, dependent: :destroy
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }

end
