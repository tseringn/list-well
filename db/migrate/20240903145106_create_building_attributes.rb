class CreateBuildingAttributes < ActiveRecord::Migration[7.1]
  def change
    create_table :building_attributes do |t|
      t.references :building, null: :false, foreign_key: :true
      t.references :attribute, null: :false, foreign_key: :true
      t.timestamps
    end
  end
end
