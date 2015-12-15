FactoryGirl.define do
  factory :user do
    name Faker::Name.name
  end

  # TODO remove if not need
  # factory :trip do
  #   title Faker::Lorem.sentence
  #   description Faker::Lorem.paragraph
  #   published false
  #   user_id 1
  #   itineraries [
  #       {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address},
  #       {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address}
  #   ]
  #   media [
  #       {image_name: Faker::Lorem.word + '.png'},
  #       {image_name: Faker::Lorem.word + '.png'}
  #   ]
  # end
end