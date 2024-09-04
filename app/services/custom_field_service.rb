class CustomFieldService
  #Create custom fields if given field is not found in the database.
  #
  # @param create_param [CustomField] Created custom field.
  # @return 
  def find_or_create(field_name, field_type, client_id)
    CustomField.find_or_create_by(field_name:field_name, field_type: field_type, client_id:client_id)
  end

  def batch_find_or_create(client_id, custom_fields)
    custom_fields.map do | custom_field |
      find_or_create(custom_field[:field_name], custom_field[:field_type], client_id)
    end
  end

  def find_all_by_client(client_id)
    CustomField.where(client_id:client_id)
  end
end