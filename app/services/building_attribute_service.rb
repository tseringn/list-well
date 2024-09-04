class BuildingAttributeService
  def create(attribute_id, building_id, attribute_value)
    BuildingAttribute.create!(
      attribute_id: attribute_id,
      building_id: building_id,
      attribute_value: attribute_value
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("BuildingAttribute creation failed: #{e.message}")
    false
  end

  def batch_create_for_building(building_id, attributes, custom_fields)
    BuildingAttribute.transaction do
      custom_fields.each do |custom_field|
        create_payload = prepare_create_payload(custom_field, attributes, building_id)
        unless create(create_payload)
          raise ActiveRecord::Rollback, "Failed to create BuildingAttribute for #{attribute_name}"
        end
      end
  
      if attributes.any?
        raise ActiveRecord::Rollback, "Failed to create BuildingAttributes due to presence of invalid custom field key(s): #{attributes.keys.join(', ')}"
      end
    end
  end
  
  def prepare_create_payload(custom_field, attributes, building_id)
    attribute_name = custom_field[:field_name]
    attribute_value = attributes.delete(attribute_name)
    custom_field_id = custom_field[:id]
    {
      attribute_value: attribute_value,
      building_id: building_id,
      custom_field_id:custom_field_id
    }
  end
end
