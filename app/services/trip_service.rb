class TripService
  attr_accessor :trip

  def initialize(trip_id = nil)
    @trip = Trip.find_by(trip_id) if trip_id
  end

  def publish_trip!
    @trip.published = true
    @trip.save!
    self
  end

  def create_trip(params)
    # TODO use transaction
    @trip = Trip.new(
        user_id: params[:user_id],
        published: params[:published],
        slug: params[:slug]
    )
    if @trip.save
      published_trip_content = @trip.create_published_trip_content(
          title: params[:title],
          description: params[:description]
      )
      draft_trip_content = @trip.create_draft_trip_content(
          title: params[:title],
          description: params[:description]
      )
      unless params[:itineraries].blank?
        create_trip_itineraries(published_trip_content, params[:itineraries])
        create_trip_itineraries(draft_trip_content, params[:itineraries])
      end
      unless params[:media].blank?
        create_trip_media(published_trip_content, params[:media])
        create_trip_media(draft_trip_content, params[:media])
      end
    end
    @trip
  end

  def save_draft_content(params)
    save_trip_content(@trip.draft_trip_content, params)
  end

  def save_published_content(params)
    save_trip_content(@trip.published_trip_content, params)
  end

  def save_and_publish(params)
    save_draft_content(params)
    save_published_content(params)
    publish_trip!
  end

  def get_published_trips
    Trip.published.eager_load(:published_trip_content).all
  end

  def get_draft_trips
    Trip.draft.eager_load(:draft_trip_content).all
  end

  # TODO remove this
  def seed_test_trips(amount = 10)
    trips = []
    amount.times do
      trips.push(Trip.create_trip(generate_test_trip_data))
    end
    trips
  end

  # TODO remove this
  def generate_test_trip_data
    {
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph,
      published: false, user_id: 1,
      itineraries: [
        {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address},
        {name: Faker::Address.country, string: Faker::Address.city + ' '  + Faker::Address.street_address}
      ],
      media: [
        {image_name: Faker::Lorem.word + '.png'},
        {image_name: Faker::Lorem.word + '.png'}
      ]
    }
  end

  def destroy_trip
    @trip.destroy
  end

  private
    def save_trip_content(trip_content, params)
      unless params[:itineraries].blank?
        update_trip_itineraries(trip_content, params[:itineraries])
      end
      unless params[:media].blank?
        update_trip_media(trip_content, params[:media])
      end
      update_trip_content(trip_content, title: params[:title], description: params[:description])
    end

    def update_trip_media(trip_content, media_params)
     trip_content.media.destroy_all
     create_trip_media(trip_content, media_params)
    end

    def update_trip_itineraries(trip_content, itinerary_params)
      trip_content.itineraries.destroy_all
      create_trip_itineraries(trip_content, itinerary_params)
    end

    def update_trip_content(trip_content, trip_content_params)
      trip_content.update_attributes(trip_content_params)
    end

    def create_trip_itineraries(trip_content, itinerary_params)
      trip_content.itineraries.create(itinerary_params)
    end

    def create_trip_media(trip_content, media_params)
      trip_content.media.create(media_params)
    end
end