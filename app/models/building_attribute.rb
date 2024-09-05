class BuildingAttribute < ApplicationRecord
  belongs_to :custom_field
  belongs_to :building
  
  before_validation :preload_custom_field

  validate :correct_field_value_type

  private

  def preload_custom_field
    self.custom_field = CustomField.find(custom_field_id) if custom_field_id.present? && custom_field.nil?
  end

  def correct_field_value_type
    return if self.field_value.nil?
    case custom_field.field_type
    when 'freeform_type'
      if valid_integer?(field_value) || valid_float?(field_value)
        errors.add(:field_value, "must be a string")
      end
    when 'number_type'
      unless valid_float?(field_value)
        errors.add(:field_value, "must be a number")
      end
    when 'enum_type'
      unless valid_integer?(field_value)
        errors.add(:field_value, "must be an integer")
      end
    end
  end

  def valid_float?(value)
    true if Float(value) rescue false
  end

  def valid_integer?(value)
    true if Integer(value) rescue false
  end
end
