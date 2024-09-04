class BuildingAttributeService
  def create(custom_field_id, building_id, field_value)

    building_attribute = BuildingAttribute.find_or_create_by(
      custom_field_id: custom_field_id,
      building_id: building_id,
      field_value: field_value
    )
    if building_attribute.persisted?
      puts "\n\n\n hi there"
      building_attribute
    else
      raise ActiveRecord::RecordInvalid.new(building_attribute)
    end
  end

  def batch_create_for_building(building_id, attributes, custom_fields)
    success = true 
    BuildingAttribute.transaction do
      custom_fields.each do |custom_field|
        payload = prepare_create_payload(attributes,custom_field)
        result = create(payload[:id], building_id, payload[:value])
        if result.nil?
          success = false
          raise ActiveRecord::Rollback, "Failed to create BuildingAttribute for building #{building_id}"
        end
      end

      if attributes.present?
        success = false 
        raise ActiveRecord::Rollback, "Failed to create BuildingAttributes due to presence of invalid custom field key(s): #{attributes.keys.join(', ')}"
      end
    end
    raise StandardError, 'Failded to create building attributes' unless success 
  end

  private

  def prepare_create_payload(attributes, custom_field)
    attribute_name = custom_field[:field_name]
    attribute_value = attributes[attribute_name] || nil
    custom_field_id = custom_field[:id]
    attributes.delete(attribute_name)
    {
      value: attribute_value,
      id: custom_field_id
    }
  end
end