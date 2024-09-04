class Building < ApplicationRecord
  has_many :building_attributes
  has_many :custom_fields, through: :building_attributes
end
