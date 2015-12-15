class Trip < ActiveRecord::Base
  belongs_to :user
  # has_many :media, as: :mediable

  has_many :trip_payments
  has_many :payments, through: :trip_payments
  # has_many :itineraries

  has_one :published_trip_content, dependent: :destroy
  has_one :draft_trip_content, dependent: :destroy
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }

  # TODO delete if not need
  def publish!
    self.published = true
    self.save!
  end

  # create and publish or create and dont publish see params[:published]
  def self.create_trip(params)
    # TODO use transaction
    trip = Trip.new(
        user_id: params[:user_id],
        published: params[:published],
        slug: params[:slug]
    )
    trip.save

    published_trip_content = trip.create_published_trip_content(
        title: params[:title],
        description: params[:description]
    )

    draft_trip_content = trip.create_draft_trip_content(
        title: params[:title],
        description: params[:description]
    )

    if params[:itineraries].any?
      # TODO move to separate methods
      published_trip_content.itineraries.create(
          params[:itineraries]
      )
      draft_trip_content.itineraries.create(
          params[:itineraries]
      )
    end

    # TODO complete this check is array
    if !params[:media].nil? && params[:media].any?
      published_trip_content.media.create(
          params[:media]
      )
      draft_trip_content.media.create(
          params[:media]
      )
    end

    trip
  end

  def save_draft_content(params)
    self.draft_trip_content.update_attributes(
        title: params[:title],
        description: params[:description]
    )
    # TODO complete deletion of old itineraries
    if params[:itineraries].any?
      self.draft_trip_content.itineraries.destroy_all

      self.draft_trip_content.itineraries.create(params[:itineraries])
    end

    # TODO complete deletion of old media files
    if params[:media].any?
      self.draft_trip_content.media.destroy_all
      self.draft_trip_content.media.create(params[:media])
    end
    self
  end


   # TODO complete published content
  def save_published_content(params)
    self.published_trip_content.update_attributes(
        title: params[:title],
        description: params[:description]
    )
    # TODO complete deletion of old itineraries
    if params[:itineraries].any?
      self.published_trip_content.itineraries.delete_all

      self.published_trip_content.itineraries.create(params[:itineraries])
    end

    # TODO complete deletion of old media files
    if params[:media].any?
      self.published_trip_content.media.delete_all
      self.published_trip_content.media.create(params[:media])
    end
    self
  end

  def save_and_publish(params)
  #   TODO complete this
    save_draft_content(params)
    save_published_content(params)
    publish!
  end

  def self.get_published_trips
    Trip.published.eager_load(:published_trip_content).all
  end

  def self.get_draft_trips
    Trip.draft.eager_load(:draft_trip_content).all
  end

  def self.seed_test_trips
    trips = []
    (1...2).each do |i|
      trips.push(Trip.create_trip(generate_test_trip_data(i)))
    end
    trips
  end

  def self.generate_test_trip_data(number = 1)
    n = number.to_s
    {
        title: 'Test title ' + n,
        description: 'Test Description ' +n,
        published: false, user_id: 1,
        itineraries: [
            {name: 'Test itierary ' + n, string: 'itinerary description ' + n},
            {name: 'test itiniary '+ n, string: 'itinerary description ' + n}
        ],
        media: [
            {image_name: 'Picture' + n + '.png'},
            {image_name: 'Picture' + n + '.png'}
        ]
    }
  end
end
