class AddLocationToIncomes < ActiveRecord::Migration[6.1]
  def change
    add_reference :incomes, :location, null: false, foreign_key: true
  end
end
