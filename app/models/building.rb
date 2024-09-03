class Building < ApplicationRecord
  has_many :building_attributes
  has_many :attributes, through: :building_attributes
end
