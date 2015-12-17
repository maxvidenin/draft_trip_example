require 'rails_helper'

describe TripService do
  let(:user) { FactoryGirl.create(:user) }
  let(:trip_service) { TripService.new }

  describe 'create valid published trip' do

    before do
      trip_service.save_trip({
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.paragraph,
        published: true,
        user_id: user.id,
        itineraries: [
          {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address},
          {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address}
        ],
        media: [
          {image_name: Faker::Lorem.word + '.png'},
          {image_name: Faker::Lorem.word + '.png'}
        ]
      })
      @trip = trip_service.trip
    end

    subject { @trip }

    it { expect(@trip.published?).to eq true }
    it { expect(trip_service.valid?).to eq true }
    it { should respond_to(:user_id) }
    it { should respond_to(:published) }
    it { should respond_to(:published_trip_content) }
    it { should respond_to(:draft_trip_content) }
    it { expect(@trip.user).to eq user }

    describe 'get draft/published versions of the trip' do
      before do
        @draft_trip_version = trip_service.get_draft_version
        @published_trip_version = trip_service.get_published_version
      end

      it { expect(@draft_trip_version.id).to eq @published_trip_version.id}
      it 'draft title and published title should be equal' do
        expect(@draft_trip_version.draft_trip_content.title
        ).to eq @published_trip_version.published_trip_content.title
      end
      it 'draft description and published title should be equal' do
        expect(@draft_trip_version.draft_trip_content.description
        ).to eq @published_trip_version.published_trip_content.description
      end
    end

    describe 'save invalid draft of existing trip' do
      before do
        trip_service.save_draft_content({
          title: Faker::Lorem.sentence,
          description: '',
          published: false,
          user_id: user.id,
          itineraries: [
            {name: Faker::Address.country}
          ],
          media: [
            {image_name: ''}
          ]
        })
      end

      it { expect(trip_service.valid?).to eq false }
      it { expect(trip_service.error_messages).not_to be_blank }
    end

    describe 'save draft of existing trip' do
      before do
        trip_service.save_draft_content({
          title: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph,
          published: false,
          user_id: user.id,
          itineraries: [
            {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address}
          ],
          media: [
            {image_name: Faker::Lorem.word + '.png'}
          ]
        })
      end

      it 'draft trip content should not be equal published trip content' do
        expect(get_content_comparable_data(@trip.draft_trip_content)
        ).not_to eq get_content_comparable_data(@trip.published_trip_content)
      end
      it 'draft trip media should not be equal published trip media' do
        expect(get_media_comparable_data(@trip.draft_trip_content.media)
        ).not_to eq get_media_comparable_data(@trip.published_trip_content.media)
      end
      it 'draft trip itineraries should not be equal published trip itineraries' do
        expect(get_itineraries_comparable_data(@trip.draft_trip_content.itineraries)
        ).not_to eq get_itineraries_comparable_data(@trip.published_trip_content.itineraries)
      end

      describe 'get draft/published versions of the trip' do
        before do
          @draft_trip_version = trip_service.get_draft_version
          @published_trip_version = trip_service.get_published_version
        end

        it { expect(@draft_trip_version.id).to eq @published_trip_version.id}
        it 'draft title and published title should be equal' do
          expect(@draft_trip_version.draft_trip_content.title
          ).not_to eq @published_trip_version.published_trip_content.title
        end
        it 'draft description and published title should be equal' do
          expect(@draft_trip_version.draft_trip_content.description
          ).not_to eq @published_trip_version.published_trip_content.description
        end
      end
    end

    describe 'save and publish existing trip' do
      before do
        trip_service.save_and_publish({
          title: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph,
          published: false,
          user_id: user.id,
          itineraries: [
            {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address}
          ],
          media: [
            {image_name: Faker::Lorem.word + '.png'},
            {image_name: Faker::Lorem.word + '.png'}
          ]
        })
        @trip = trip_service.trip
      end

      it { expect(@trip.published?).to eq true }

      it 'trip content data after publishing should be equal' do
        expect(get_content_comparable_data(@trip.draft_trip_content)
        ).to eq get_content_comparable_data(@trip.published_trip_content)
      end
      it 'trip media data after publishing should be equal' do
        expect(get_media_comparable_data(@trip.draft_trip_content.media)
        ).to eq get_media_comparable_data(@trip.published_trip_content.media)
      end
      it 'trip itineraries data after publishing should be equal' do
        expect(get_itineraries_comparable_data(@trip.draft_trip_content.itineraries)
        ).to eq get_itineraries_comparable_data(@trip.published_trip_content.itineraries)
      end
    end

    describe 'unpublish existing trip' do
      before {trip_service.unpublish_trip!}
      it { expect(@trip.published?).to eq false }
    end

    describe 'publish existing draft trip' do
      before do
        trip_service.unpublish_trip!
        trip_service.save_draft_content({
          title: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph,
          published: false,
          user_id: user.id,
          itineraries: [
            {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address},
            {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address}
          ],
          media: [
            {image_name: Faker::Lorem.word + '.png'},
            {image_name: Faker::Lorem.word + '.png'},
            {image_name: Faker::Lorem.word + '.png'}
          ]
        })
        trip_service.publish_trip!
      end
      it { expect(@trip.published?).to eq true }

      it 'trip content data after publishing should be equal' do
        expect(get_content_comparable_data(@trip.draft_trip_content)
        ).to eq get_content_comparable_data(@trip.published_trip_content)
      end
      it 'trip media data after publishing should be equal' do
        expect(get_media_comparable_data(@trip.draft_trip_content.media)
        ).to eq get_media_comparable_data(@trip.published_trip_content.media)
      end
      it 'trip itineraries data after publishing should be equal' do
        expect(get_itineraries_comparable_data(@trip.draft_trip_content.itineraries)
        ).to eq get_itineraries_comparable_data(@trip.published_trip_content.itineraries)
      end
    end

    describe 'delete existing trip' do
      subject { -> { trip_service.destroy_trip } }
      it { should change(Trip, :count).by(-1) }
      it { should change(TripContent, :count).by(-2) }
      it { should change(Itinerary, :count).by(-2) }
      it { should change(Medium, :count).by(-4) }
    end
  end

  describe 'create invalid trip' do
    before do
      trip_service.save_trip({
         title: Faker::Lorem.sentence,
         description: '',
         published: true,
         user_id: user.id,
         itineraries: [
           {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address},
           {name: Faker::Address.country, string: ''}
         ],
         media: [
           {image_name: Faker::Lorem.word + '.png'},
           {}
         ]
     })
    end

    it { expect(trip_service.valid?).to eq false }
    it { expect(trip_service.error_messages).not_to be_blank }
  end

  describe 'get list of published trips' do

    before do
      @trips = []
      10.times do
        trip_service.save_trip({
           title: Faker::Lorem.sentence,
           description: Faker::Lorem.paragraph,
           published: true,
           user_id: user.id,
           itineraries: [
               {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address}
           ]
         })
        @trips.push(trip_service.trip)
      end
    end

    subject { @trips }

    it { expect(@trips.count).to eq 10 }
    it { expect(trip_service.get_published_trips).to eq @trips }
    it { expect(@trips.sample.published?).to eq true }
  end

  describe 'get list of draft trips' do

    before do
      @trips = []
      5.times do
        trip_service.save_trip({
           title: Faker::Lorem.sentence,
           description: Faker::Lorem.paragraph,
           published: false,
           user_id: user.id,
           media: [
             {image_name: Faker::Lorem.word + '.png'}
           ]
         })
        @trips.push(trip_service.trip)
      end
    end

    subject { @trips }

    it { expect(@trips.count).to eq 5 }
    it { expect(trip_service.get_draft_trips).to eq @trips }
    it { expect(trip_service.get_published_trips).not_to eq @trips }
    it { expect(@trips.sample.published?).to eq false }
  end

  def get_content_comparable_data(trip_content)
    {title: trip_content.title, description: trip_content.description}
  end

  def get_media_comparable_data(trip_media)
    trip_media.map { |media| { image_name: media.image_name} }
  end

  def get_itineraries_comparable_data(trip_itineraries)
    trip_itineraries.map { |itinerary| { name: itinerary.name, string: itinerary.string} }
  end
end