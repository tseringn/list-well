class LocationService
  def create(location_params)
    location = Location.create(location_params)
    if location.persisted?
      location
    else
      raise ActiveRecord::RecordInvalid.new(location)
    end
  end

  def update(location_params)
    location = Location.find_or_create_by(building_id: location_params[:building_id])
    location.assign_attributes(location_params)
    if location.save
      location
    else
      raise ActiveRecord::RecordInvalid.new(location)
    end
  end
end