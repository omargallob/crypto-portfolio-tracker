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

ActiveRecord::Schema.define(version: 20180119151943) do

  create_table "balances", force: :cascade do |t|
    t.integer "wallet_id"
    t.float "amount"
    t.float "avg_buy_price_in_btc"
    t.float "avg_sell_price_in_btc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wallet_id"], name: "index_balances_on_wallet_id"
  end

  create_table "exchanges", force: :cascade do |t|
    t.string "name"
    t.string "api"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movements", force: :cascade do |t|
    t.integer "balance_id"
    t.string "movement_type"
    t.string "timestamp"
    t.string "fee"
    t.string "timestamp_created"
    t.string "txid"
    t.string "description"
    t.string "status"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "currency"
    t.string "method"
    t.string "amount"
    t.index ["balance_id"], name: "index_movements_on_balance_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "balance_id"
    t.string "tid"
    t.string "order_id"
    t.float "amount"
    t.float "price"
    t.float "price_in_usd"
    t.string "timestamp"
    t.string "pair"
    t.string "fee_currency"
    t.float "fee_amount"
    t.string "order_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balance_id"], name: "index_orders_on_balance_id"
  end

  create_table "txes", force: :cascade do |t|
    t.integer "balance_id"
    t.string "timestamp"
    t.string "type"
    t.string "amount"
    t.boolean "written_off"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tid"
    t.string "order_id"
    t.string "price"
    t.string "pair"
    t.string "fee_currency"
    t.string "fee_amount"
    t.string "fee"
    t.string "timestamp_created"
    t.string "txid"
    t.text "description"
    t.string "status"
    t.string "address"
    t.string "currency"
    t.string "method"
    t.string "order_type"
    t.string "movement_type"
    t.index ["balance_id"], name: "index_txes_on_balance_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.integer "exchange_id"
    t.string "name"
    t.string "ticker"
    t.string "amount"
    t.string "available"
    t.string "wallet_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exchange_id"], name: "index_wallets_on_exchange_id"
  end

end
