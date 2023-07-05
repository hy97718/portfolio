class CreateFixedCosts < ActiveRecord::Migration[6.1]
  def change
    create_table :fixed_costs do |t|
      t.string :fixed_cost_name
      t.string :recurring_period
      t.integer :recurring_day
      t.integer :fixed_cost_money
      t.date :recurring_start_date
      t.date :recurring_end_date
      t.references :user, foreign_key: true
      t.references :location, foreign_key: true
      t.timestamps
    end
  end
end
