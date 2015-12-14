class Medium < ActiveRecord::Base
  belongs_to :mediable, polymorphic: true
end
