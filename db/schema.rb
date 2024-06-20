# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170305211932) do

  create_table "cocktails", force: :cascade do |t|
    t.string   "name",       limit: 60,                   null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sort_name",  limit: 60
    t.string   "technique",             default: "shake", null: false
  end

  create_table "cocktails_garnishes", primary_key: "false", force: :cascade do |t|
    t.integer  "cocktail_id"
    t.integer  "garnish_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "garnishes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredient_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredient_categories_on_name"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name",                   limit: 60, null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ingredient_category_id"
  end

  create_table "recipe_items", force: :cascade do |t|
    t.integer  "cocktail_id",   null: false
    t.integer  "ingredient_id", null: false
    t.float    "amount"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["cocktail_id", "ingredient_id"], name: "index_recipe_items_on_cocktail_id_and_ingredient_id"
  end

  create_table "units", force: :cascade do |t|
    t.string   "name",           limit: 40, null: false
    t.string   "abbreviation",   limit: 4,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "size_in_ounces"
  end

end
