# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

# Clear existing data
puts "clearing mess" 
BuildingAttribute.destroy_all
Building.destroy_all
Location.destroy_all
CustomField.destroy_all
Client.destroy_all
puts "pouring fresh water ..."
# Seed Clients and CustomFields
10.times do
  client = Client.create(
    name: Faker::Company.name
  )

  # Add custom fields to each client
 rand(1..7).times do
    client.custom_fields.create(
      field_name: Faker::Lorem.word,
      field_type: ['enum_type', 'freeform_type', 'number_type'].sample
    )
  end
  rand(15..21).times do
    client.buildings.create(   
    name: Faker::Company.name + " Building",
    year_built: rand(1900..2020),
    lot_area: "#{Faker::Number.decimal(l_digits: 3, r_digits: 2)} sq.ft"
    )
  end
end
puts "create #{Client.count} clients, #{Building.count} buildings and #{CustomField.count} custom fields"

buildings = Building.all
buildings.each do | building|
  Location.create(
    name: Faker::Address.community,
    address: Faker::Address.full_address,
    lat: Faker::Address.latitude,
    lng: Faker::Address.longitude,
    building_id: building.id
  )
  building_client = Client.find(building.client_id)
  building_client.custom_fields.each do | custom_field |
    field_value =''
    case custom_field.field_type
    when 'enum_type'
      field_value = Faker::Number.between(from: 1, to: 100)
    when 'number_type'
      field_value = Faker::Number.decimal(l_digits: 2, r_digits: 3) 
    when 'freeform_type'
      field_value = Faker::Lorem.word
    end
    BuildingAttribute.create(
      building_id: building.id,
      custom_field_id: custom_field.id,
      field_value: [field_value,nil].sample
    )
  end
end
puts "generated #{Location.count} and #{BuildingAttribute.count} building attributes! crazy!"