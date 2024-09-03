class AddReferences < ActiveRecord::Migration[7.1]
  def change
    add_reference :buildings, :location, foreign_key: :true
    add_reference :buildings, :client, null: :false, foreign_key: :true
  end
end
