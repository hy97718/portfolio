class AddMaxExpenseToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :max_expense, :integer
  end
end
