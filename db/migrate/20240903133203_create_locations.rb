class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.string :string
      t.string :coordinates
      t.string :jsonob

      t.timestamps
    end
  end
end
