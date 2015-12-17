class Medium < ActiveRecord::Base
  validates :image_name, :mediable_type, :mediable_id, presence: true
  belongs_to :mediable, polymorphic: true
end
