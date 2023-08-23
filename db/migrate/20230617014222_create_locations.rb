class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :asset_name
      t.string :location_name
      t.integer :max_expense
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
