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

ActiveRecord::Schema.define(version: 2018_04_23_031848) do

  create_table "delivers", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loteria", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string "amount_tck"
    t.string "currency"
    t.string "status"
    t.string "address_payment"
    t.string "address_receive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "premiados", force: :cascade do |t|
    t.string "sorteio_id"
    t.string "wallet"
    t.string "qtd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "premio_entregue"
    t.string "position"
    t.string "currency"
  end

  create_table "sorteios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.string "wallet"
    t.string "size"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
  end

end
