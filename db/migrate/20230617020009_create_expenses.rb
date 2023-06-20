class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.string :expense_name
      t.integer :expense_money
      t.date :expense_day
      t.text :expense_memo
      t.references :user, foreign_key: true
      t.references :location, foreign_key: true
      t.timestamps
    end
  end
end
