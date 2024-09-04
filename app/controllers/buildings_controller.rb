class BuildingsController < ApplicationController
    before_action :set_client, only: %i[ show update destroy ]
  
    # GET /building
    def index
      @building = Building.all
  
      render json: @building, include: :building_attributes
    end
  
    # GET /buildings/1
    def show
      render json: @building
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
      if @building.update(building_params)
        render json: @building
      else
        render json: @building.errors, status: :unprocessable_entity
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
        params.require(:building).permit(:name,:year_built, :lot_area, :client_id, attributes:{})
      end
  
end
