class LocationService
  def initialize(params)
    @params =params
  end

  def create ()
    begin
      Location.create!(@params)
    rescue ActiveRecord::RecordInvalid => e
      puts "Location creation failed: #{e.message}"
    end
  end
end