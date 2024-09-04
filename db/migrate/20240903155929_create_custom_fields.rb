class CreateCustomFields < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_fields do |t|
      t.string :field_name
      t.string :field_type
      t.timestamps
      t.references :client, null: :false, foreign_key: :true
    end
  end
end
