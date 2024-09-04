class BuildingsController < ApplicationController
    before_action :set_client, only: %i[ show update destroy ]
  
    # GET /building
    def index
      @building = Client.all
  
      render json: @building, include: :custom_fields
    end
  
    # GET /buildings/1
    def show
      render json: @building
    end
  
    # POST /buildings
    def create
      building_service = BuildingService.new
      custom_field_service = CustomFieldService.new()
      @building = building_service.create(building_params.except(:attributes))
      if @building
        custom_fields_params = building_params[:attributes]||[]
        custom_field_service.batch_find_or_create(@building[:id],custom_fields_params)
        render json: @building, status: :created, location: @building
      else
        render json: @building.errors, status: :unprocessable_entity
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
        params.require(:building).permit(:name,:year_built, :lot_area, :client_id, attributes:[:value])
      end
  
end
