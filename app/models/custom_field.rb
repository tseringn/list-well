class CustomField < ApplicationRecord
  belongs_to :client
  has_many :building_attributes
  has_many :buildings, through: :building_attributes
  enum field_type: {freeform_type: 'freeform', number_type: 'number', enum_type: 'enum'}
end
