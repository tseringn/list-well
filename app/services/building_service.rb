class BuildingService
  def initialize(custom_fields, create_params)
    @custom_fields = custom_fields
    @create_params = create_params
  end

  def create
    building_attribute_service = BuildingAttributeService.new
    
    Building.transaction do
      building = Building.new(@create_params.except(:attributes))
      
      if building.save
        attributes_params = @create_params[:attributes] || []
        
        begin
          building_attribute_service.batch_create_for_building(building.id, attributes_params, @custom_fields)
        rescue StandardError => e
          Rails.logger.error("Create attributes failed: #{e.message}")
          raise ActiveRecord::Rollback
        end
        
      else
        raise ActiveRecord::Rollback, "Building could not be saved"
      end
    end

    true 
  rescue => e
    Rails.logger.error("Transaction failed: #{e.message}")
    false
  end
end
