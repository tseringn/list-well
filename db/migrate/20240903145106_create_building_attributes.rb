class CreateBuildingAttributes < ActiveRecord::Migration[7.1]
  def change
    create_table :building_attributes do |t|
      t.string :field_value
      t.references :building, null: :false, foreign_key: :true
      t.references :custom_field, null: :false, foreign_key: :true
      t.timestamps
    end
  end
end
