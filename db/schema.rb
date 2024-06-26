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

ActiveRecord::Schema[7.1].define(version: 2024_06_24_182720) do
  create_table "cocktails", force: :cascade do |t|
    t.string "name", limit: 60, null: false
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "sort_name", limit: 60
    t.string "technique", default: "shake", null: false
  end

  create_table "cocktails_garnishes", primary_key: "false", force: :cascade do |t|
    t.integer "cocktail_id"
    t.integer "garnish_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "garnishes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredient_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredient_categories_on_name"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name", limit: 60, null: false
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "ingredient_category_id"
  end

  create_table "recipe_items", force: :cascade do |t|
    t.integer "cocktail_id", null: false
    t.integer "ingredient_id", null: false
    t.float "amount"
    t.integer "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["cocktail_id", "ingredient_id"], name: "index_recipe_items_on_cocktail_id_and_ingredient_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name", limit: 40, null: false
    t.string "abbreviation", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "size_in_ounces"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "confirmed_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
