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

ActiveRecord::Schema.define(version: 20180124182351) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "balances", force: :cascade do |t|
    t.bigint "wallet_id"
    t.float "amount"
    t.float "avg_buy_price_in_btc"
    t.float "avg_sell_price_in_btc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avg_buy_price_per_unit"
    t.string "avg_sell_price_per_unit"
    t.string "avg_price_per_unit"
    t.string "breakeven_price"
    t.index ["wallet_id"], name: "index_balances_on_wallet_id"
  end

  create_table "exchanges", force: :cascade do |t|
    t.string "name"
    t.string "api"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trading_pairs", force: :cascade do |t|
    t.bigint "balance_id"
    t.string "name"
    t.string "avg_sell_price"
    t.string "avg_buy_price"
    t.string "breakeven_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balance_id"], name: "index_trading_pairs_on_balance_id"
  end

  create_table "txes", force: :cascade do |t|
    t.bigint "balance_id"
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
    t.string "remote_id"
    t.boolean "invalidated", default: false
    t.string "value_in_btc_at_time_of_movement"
    t.integer "trading_pair_id"
    t.index ["balance_id"], name: "index_txes_on_balance_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "exchange_id"
    t.string "name"
    t.string "ticker"
    t.string "amount"
    t.string "available"
    t.string "wallet_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avg_cost_per_unit"
    t.boolean "is_penny_coin"
    t.index ["exchange_id"], name: "index_wallets_on_exchange_id"
  end

  add_foreign_key "balances", "wallets"
  add_foreign_key "txes", "balances"
end
