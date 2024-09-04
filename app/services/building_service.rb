class BuildingService
  def create ()
    begin
      Client.create!(@params)
    rescue ActiveRecord::RecordInvalid => e
      puts "Building creation failed: #{e.message}"
    end
  end
end