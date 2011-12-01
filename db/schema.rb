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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111118122713) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.decimal  "price",       :precision => 8, :scale => 2
    t.integer  "currency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "complects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currencies", :force => true do |t|
    t.string   "name"
    t.string   "full_name"
    t.string   "char_code",  :limit => 3
    t.integer  "num_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "email"
    t.text     "passport"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dealers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "defects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "external_states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goals", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grounds", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "internal_states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "netzke_temp_table", :force => true do |t|
  end

  create_table "numerators", :force => true do |t|
    t.string  "name",                          :null => false
    t.integer "repair_type_id"
    t.integer "current_value",  :default => 0
  end

  create_table "orders", :force => true do |t|
    t.integer  "number"
    t.integer  "ticket"
    t.text     "diag_result"
    t.text     "diag_ground"
    t.text     "actual_defect"
    t.integer  "diag_manager_id"
    t.decimal  "diag_price",              :precision => 8, :scale => 2
    t.integer  "customer_id"
    t.integer  "manager_id"
    t.date     "applied_at"
    t.date     "plan_deliver_at"
    t.date     "actual_deliver_at"
    t.date     "diagnosed_at"
    t.date     "work_performed_at"
    t.decimal  "prior_cost",              :precision => 8, :scale => 2
    t.decimal  "maximum_cost",            :precision => 8, :scale => 2
    t.string   "guarantee_case"
    t.integer  "deliver_manager_id"
    t.decimal  "discount"
    t.string   "discount_type"
    t.text     "discount_ground"
    t.text     "service_info"
    t.text     "service_state"
    t.text     "service_note"
    t.text     "service_phone_agreement"
    t.integer  "complect_id"
    t.integer  "repair_type_id"
    t.integer  "external_state_id"
    t.integer  "internal_state_id"
    t.integer  "reason_id"
    t.integer  "goal_id"
    t.integer  "status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_passport_id"
    t.integer  "result_id"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "people", ["reset_password_token"], :name => "index_people_on_reset_password_token", :unique => true
  add_index "people", ["username"], :name => "index_people_on_username", :unique => true

  create_table "producers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_passports", :force => true do |t|
    t.integer  "producer_id"
    t.integer  "products_id"
    t.string   "factory_number"
    t.string   "guarantee_stub_number"
    t.integer  "purchase_place_id"
    t.date     "purchased_at"
    t.integer  "dealer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "producer_id"
  end

  create_table "purchase_places", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reasons", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repair_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.string   "name"
    t.string   "template_file"
    t.string   "friendly_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
