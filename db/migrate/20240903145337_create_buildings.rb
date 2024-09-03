class CreateBuildings < ActiveRecord::Migration[7.1]
  def change
    create_table :buildings do |t|
      t.string :name
      t.integer :year_built
      t.decimal :area
      t.timestamps
    end
  end
end
