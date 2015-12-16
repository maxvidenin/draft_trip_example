class TripService
  attr_accessor :trip, :error_messages

  def initialize(trip_id = nil)
    @trip = Trip.find_by(trip_id) if trip_id
    @error_messages = {}
  end

  def save_trip(params)
    @trip = Trip.new(
        user_id: params[:user_id],
        published: params[:published],
        slug: params[:slug]
    )
    ActiveRecord::Base.transaction do
      begin
        if @trip.save
          published_trip_content = @trip.build_published_trip_content(
              title: params[:title],
              description: params[:description]
          )
          if !published_trip_content.save
            add_error_messages(:trip_content, published_trip_content.errors.full_messages)
          end

          draft_trip_content = @trip.build_draft_trip_content(
              title: params[:title],
              description: params[:description]
          )
          if !draft_trip_content.save
            add_error_messages(:trip_content, draft_trip_content.errors.full_messages)
          end

          unless params[:itineraries].blank?
            save_trip_itineraries(published_trip_content, [])
            save_trip_itineraries(draft_trip_content, params[:itineraries])
          end
          unless params[:media].blank?
            save_trip_media(published_trip_content, params[:media])
            save_trip_media(draft_trip_content, params[:media])
          end
          return true
        else
          add_error_messages(:trip, @trip.errors.full_messages)
        end
      rescue
        raise ActiveRecord::Rollback
      end
    end
    return false
  end

  def save_draft_content(params)
    save_trip_content(@trip.draft_trip_content, params)
  end

  def save_published_content(params)
    save_trip_content(@trip.published_trip_content, params)
  end

  def save_and_publish(params)
    save_draft_content(params)
    publish_trip!
  end

  def get_published_trips
    Trip.published.eager_load(:published_trip_content).all
  end

  def get_draft_trips
    Trip.draft.eager_load(:draft_trip_content).all
  end

  def get_draft_version
    @trip.draft_trip_content
  end

  def get_published_version
    @trip.published_trip_content
  end

  def publish_trip!
    params = {
      title: @trip.draft_trip_content.title,
      description: @trip.draft_trip_content.description,
      itineraries: @trip.draft_trip_content.itineraries.map {|itinerary| {name: itinerary.name, string: itinerary.string}},
      media: @trip.draft_trip_content.media.map {|media| {image_name: media.image_name}}
    }

    save_published_content(params)
    @trip.published = true
    @trip.save!
    self
  end

  def unpublish_trip!
    @trip.published = false
    @trip.save!
    self
  end

  def destroy_trip
    @trip.destroy
  end

  def valid?
    @error_messages.blank?
  end

  private
    def save_trip_content(trip_content, params)
      ActiveRecord::Base.transaction do
        begin
          update_trip_content(trip_content, title: params[:title], description: params[:description])
          unless params[:itineraries].blank?
            update_trip_itineraries(trip_content, params[:itineraries])
          end
          unless params[:media].blank?
            update_trip_media(trip_content, params[:media])
          end
          if @error_messages.blank?
            return true
          else
            raise ActiveRecord::Rollback
          end
        rescue
          raise ActiveRecord::Rollback
        end
      end
      return false
    end

    def update_trip_media(trip_content, media_params)
     trip_content.media.destroy_all
     save_trip_media(trip_content, media_params)
    end

    def update_trip_itineraries(trip_content, itinerary_params)
      trip_content.itineraries.destroy_all
      save_trip_itineraries(trip_content, itinerary_params)
    end

    def update_trip_content(trip_content, trip_content_params)
      if !trip_content.update_attributes(trip_content_params)
        add_error_messages(:trip_content, trip_content.errors.full_messages)
      end
    end

    def save_trip_itineraries(trip_content, itinerary_params)
      itinerary_params.each do |itinerary|
        itinerary_content = trip_content.itineraries.build(itinerary)
        if !itinerary_content.save
          add_error_messages(:itinerary, itinerary_content.errors.full_messages)
        end
      end
    end

    def save_trip_media(trip_content, media_params)
      media_params.each do |media|
        media_content = trip_content.media.build(media)
        if !media_content.save
          add_error_messages(:media, media_content.errors.full_messages)
        end
      end
    end

    def add_error_messages(key, error_messages = [])
      @error_messages[key] = error_messages if error_messages.any?
    end
end