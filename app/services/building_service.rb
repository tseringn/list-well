class BuildingService
  def initialize(custom_fields, building_params)
    @custom_fields = custom_fields
    @building_params = building_params
  end

  def create
    building_attribute_service = BuildingAttributeService.new
    location_service = LocationService.new
    success = true
    Building.transaction do
      building = Building.new(@building_params.except(:attributes,:location)) 
      
      if building.save
        attributes = @building_params[:attributes] || []
        location_params = @building_params[:location] 
        begin
          building_attribute_service.batch_create_for_building( 
            building.id,
            attributes
            @custom_fields
            )
          next if location_params.nil?
          location_params[:building_id] = building[:id]
          location_service.create(location_params)    
        rescue => e
          success = false 
          Rails.logger.error("Transaction failed: #{e.message}")
          raise ActiveRecord::Rollback
        end

      else
        success = false
        Rails.logger.error("Couldn't save building")
        raise ActiveRecord::Rollback, "Building could not be saved"
      end
    end

    success 
  rescue => e
    Rails.logger.error("Transaction failed: #{e.message}")
    false
  end

  def update(id)
    building_attribute_service = BuildingAttributeService.new
    location_service = LocationService.new
    success = true
    Building.transaction do
      building = Building.find(id)
      building.assign_attributes(@building_params.except(:attributes,:location))
      
      if building.save
        attributes = @building_params[:attributes] || []
        location_params = @building_params[:location] 
        begin
          building_attribute_service.batch_update_for_building( 
            building.id,
            attributes,
            @custom_fields,
            )
          next if location_params.nil?
          location_params[:building_id] = building[:id]
          location_service.update(location_params)    
        rescue => e
          success = false 
          Rails.logger.error("Transaction failed: #{e.message}")
          raise ActiveRecord::Rollback
        end

      else
        success = false
        Rails.logger.error("Couldn't update building")
        raise ActiveRecord::Rollback, "Building could not be udpated"
      end
    end

    success 
  rescue => e
    Rails.logger.error("Transaction failed: #{e.message}")
    false
  end 
end
