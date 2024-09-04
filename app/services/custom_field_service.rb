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
  private
# Find attributes with given name and field_type if exist.
#
# @param name [string] Attribute field name.
# @param field_type [enum] The attribute field type.
# @return [Attribute] The attribute if found in the database.
  def get_if_existed(name, field_type, client_id)
    CustomField.find_or_create_by(field_name:name, field_type: field_type, client_id:client_id)
  end
# # Determines attribute field type and processes create payload. 
# # 
# # @param attribute_name [string] The key of the custom field. 
# # @param attribute_value [Integer][Float][String] The value of custome field.
#   def process_attribute_keys(atrribute_name, attribute_value)
#     create_payload = { field_type: nil, name: atrribute_name }
#     case attribute_value
#     when Integer
#       create_payload[:field_type] = :enum
#     when Float
#       create_payload[:field_type] = :decimal
#     when String
#       create_payload[:field_type]= :freeform
#     end
#   end
end