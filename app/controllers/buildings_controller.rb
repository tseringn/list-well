class BuildingsController < ApplicationController
    before_action :set_building, only: %i[ show update destroy ]
  
    # GET /building
    def index
      page_number = (params[:page] || 1).to_i
      per_page = 10
      offset = (page_number - 1) * per_page
      @buildings = Building.includes(:location, building_attributes: :custom_field)
      .limit(per_page)
      .offset(offset)
                  
      formatted_buildings = format_buildings_request(@buildings)

      render json: { 
        buildings: formatted_buildings,
        current_page: page_number,
        per_page: per_page,
        total_count: Building.count 
      }
    end
  
    # GET /buildings/1
    def show
      formatted_building = format_building_request(@building)
      render json: { building: formatted_building }
    end
  
    # POST /buildings
    def create
      custom_field_service = CustomFieldService.new()
      custom_fields = custom_field_service.find_all_by_client(building_params[:client_id])
      building_service = BuildingService.new(custom_fields,building_params)
      building_created = building_service.create
      
      if building_created
        render json: {message: 'building created scuccesfully!'}, status: :created
      else
        render json: {message: 'create building failed'}, status: :unprocessable_entity
      end 
    end
  
    # PATCH/PUT /building/1
    def update
      custom_field_service = CustomFieldService.new()
      custom_fields = custom_field_service.find_all_by_client(building_params[:client_id])
      building_service = BuildingService.new(custom_fields, building_params)
      building_updated = building_service.update(params[:id])
      if building_updated 
        render json: {message: 'building updated scuccesfully!'}, status: :ok
      else
        render json: {message: 'update building failed'}, status: :unprocessable_entity
      end
    end
  
    # DELETE /building/1
    def destroy
      @building.destroy!
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_building
        @building = Building.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def building_params
        params.require(:building).permit!
      end
      
      def format_buildings_request(buildings)
        building_attribute_service = BuildingAttributeService.new
    
        buildings.map do |building|
          formatted_building = {
            id: building.id,
            name: building.name,
            year_built: building.year_built,
            location: building.location,
            attributes: building_attribute_service.get_mapped_attributes_custom_fields(building.building_attributes)
          }
          formatted_building
        end
      end

      def format_building_request(building)
        building_attribute_service = BuildingAttributeService.new
        {
          id: building.id,
          name: building.name,
          year_built: building.year_built,
          location: building.location,
          attributes: building_attribute_service.get_mapped_attributes_custom_fields(building.building_attributes)
        }
      end
end
