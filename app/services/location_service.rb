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
    location = Location.find(location_params[:id])
    location.assign_attributes(location_params)
    if location.save
      location
    else
      raise ActiveRecord::RecordInvalid.new(location)
    end
  end
end