class CreateIncomes < ActiveRecord::Migration[6.1]
  def change
    create_table :incomes do |t|
      t.references :user, null: false, foreign_key: true
      t.date :income_day
      t.integer :income_money
      t.string :income_memo
      t.references :location, foreign_key: true
      t.timestamps
    end
  end
end
