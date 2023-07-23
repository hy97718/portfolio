# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_06_27_023618) do

  create_table "dashboards", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_dashboards_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "expense_name"
    t.integer "expense_money"
    t.date "expense_day"
    t.text "expense_memo"
    t.integer "user_id"
    t.integer "location_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["location_id"], name: "index_expenses_on_location_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "incomes", force: :cascade do |t|
    t.string "income_name"
    t.integer "user_id", null: false
    t.date "income_day"
    t.integer "income_money"
    t.string "income_memo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "location_id", null: false
    t.index ["location_id"], name: "index_incomes_on_location_id"
    t.index ["user_id"], name: "index_incomes_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "asset_name"
    t.string "location_name"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "max_expense"
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "searches", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.integer "savings_target"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "dashboards", "users"
  add_foreign_key "expenses", "locations"
  add_foreign_key "expenses", "users"
  add_foreign_key "incomes", "locations"
  add_foreign_key "incomes", "users"
  add_foreign_key "locations", "users"
  add_foreign_key "searches", "users"
end
