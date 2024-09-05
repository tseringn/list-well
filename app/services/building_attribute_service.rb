class BuildingAttributeService
  def create(create_params)
    building_attribute = BuildingAttribute.find_or_create_by(create_params)
    if building_attribute.persisted?
      building_attribute
    else
      raise ActiveRecord::RecordInvalid.new(building_attribute)
    end
  end

  def update(update_params)
    building_attribute = BuildingAttribute.find(update_params[:id])
    building_attribute.assign_attributes(update_params.except(:id))
    if building_attribute.save
      building_attribute
    else
      raise ActiveRecord::RecordInvalid.new(building_attribute)
    end
  end

  def batch_create_for_building(building_id, attributes, custom_fields)
    success = true 
    BuildingAttribute.transaction do
      custom_fields.each do | custom_field |
        payload = prepare_upsert_payload(attributes, custom_field)
        payload[:building_id] = building_id
        result = create(payload)
          
        if result.nil?
          success = false
          raise ActiveRecord::Rollback, "Failed to create BuildingAttribute for building #{building_id}"
        end
      end
      
      unless attributes.empty?
        success = false 
        joined_keys = get_attributes_keys(attributes).join(", ")
        raise ActiveRecord::Rollback, "Failed to create BuildingAttributes due to presence of invalid custom field key(s): #{joined_keys}"
      end
    end
    raise StandardError, 'Failded to update building attributes' unless success 
  end

  def batch_update_for_building(building_id, attributes, custom_fields)
    success = true 
    BuildingAttribute.transaction do
      custom_fields.each do |custom_field|
        payload = prepare_upsert_payload(attributes, custom_field, true)
        
        next if payload.nil?
        payload[:building_id] = building_id
        result = update(payload)
        if result.nil?
          success = false
          raise ActiveRecord::Rollback, "Failed to update BuildingAttribute for building #{building_id}"
        end
      end
      unless attributes.empty?
        success = false 
        joined_keys = get_attributes_keys(attributes).join(", ")
        raise ActiveRecord::Rollback, "Failed to update BuildingAttributes due to presence of invalid custom field key(s): #{joined_keys}"
      end
    end
    raise StandardError, 'Failded to update building attributes' unless success 
  end

  def get_mapped_attributes_custom_fields(building_attributes)
    attributes = {}
    building_attributes.each do |attribute|
      attributes[attribute.custom_field.field_name]= attribute.field_value
    end
    attributes
  end

  private

  def prepare_upsert_payload(attributes, custom_field, update_mode=false)

    attribute_name = custom_field[:field_name]

    target_attribute = attributes.find do | attribute |
      attribute.has_key?(attribute_name)
    end
    return nil if target_attribute.nil? && update_mode
    if target_attribute.nil?
      target_attribute ={}
      target_attribute[:field_value] = nil 
    else
      target_attribute[:field_value] = target_attribute[attribute_name]
      target_attribute.delete(attribute_name)
      attributes.delete(target_attribute)
    end
    target_attribute[:custom_field_id] = custom_field[:id]
    return target_attribute
  end

  def get_attributes_keys(attributes)
    attributes.map do |attribute|
      attribute.keys.detect do |key|
        key != 'id'
      end
    end
  end

end