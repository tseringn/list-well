class BuildingAttribute < ApplicationRecord
  belongs_to :custom_field
  belongs_to :building
end
