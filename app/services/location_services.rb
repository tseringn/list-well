class LocationService
  def initialize(params)
    @params =params
  end

  def create () 
    Location.create(@params)
  end

end