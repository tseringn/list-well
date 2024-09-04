class BuildingAttributeService 
  def create(attribute_id, building_id, attribute_value)
    begin
      BuildingAttribute.create!(
        attribute_id:attribute_id,
        building_id:building_id,
        attribute_value:attribute_value
        )
    rescue
        ActiveRecord::RecordInvalid => e
        puts "Building creation failed: #{e.message}"
    end
  end
  def batch_create_for_building(building_id, attributes,custom_fields)
    attributes = attributes.map do |attribute|
      attribute_name = attribute[:name]
      attribute_value = custom_fields[attribute_name]
      create(attribute[:id],building_id,attribute_value)
    end
  end
end