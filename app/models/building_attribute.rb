class BuildingAttribute < ApplicationRecord
  belongs_to :attribute
  belongs_to :building
end
