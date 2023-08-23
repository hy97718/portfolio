class CreateDashboards < ActiveRecord::Migration[6.1]
  def change
    create_table :dashboards do |t|
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
