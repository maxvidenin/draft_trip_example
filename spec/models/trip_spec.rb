require 'rails_helper'

describe Trip do
  let(:user) { FactoryGirl.create(:user) }
  let(:trip_service) { TripService.new }

  before do
    @trip = trip_service.create_trip(
      {
        title: Faker::Lorem.sentence,
        # description: Faker::Lorem.paragraph,
        published: false,
        user_id: user.id,
        itineraries: [
          {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address},
          {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address}
        ],
        media: [
          {image_name: Faker::Lorem.word + '.png'},
          {image_name: Faker::Lorem.word + '.png'}
        ]
      }
    )
  end

  subject { @trip }

  it { should respond_to(:user_id) }
  it { should respond_to(:published) }
  it { should respond_to(:published_trip_content) }
  it { should respond_to(:draft_trip_content) }
  it { expect(@trip.user).to eq user }

  # puts user
  # p @trip.errors.full_messages
  it do
    p @trip.errors.full_messages
  end
end