class CreateSearches < ActiveRecord::Migration[6.1]
  def change
    create_table :searches do |t|
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
