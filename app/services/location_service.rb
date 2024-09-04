class LocationService
  def create(location_params)
    location = Location.create(location_params)
    if location.persisted?
      location
    else
      raise ActiveRecord::RecordInvalid.new(location)
    end
  end
end