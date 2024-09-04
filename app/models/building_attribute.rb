class BuildingAttribute < ApplicationRecord
  belongs_to :custom_field
  belongs_to :building
  validate :correct_field_value_type
  
  private 
  def correct_field_value_type
    case custom_field.field_type
    when 'freeform_type'
      errors.add(:field_value, "must be a string") unless value.is_a?(String)
    when 'decimal_type'
      errors.add(:field_value, "must be a decimal") unless value.is_a?(Float)
    when 'enum_type'
      errors.add(:field_value, "must be a string") unless value.is_a?(Integer)
    end
  end
end
