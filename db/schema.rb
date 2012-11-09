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

ActiveRecord::Schema.define(:version => 20121109145250) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.decimal  "price",                :precision => 8, :scale => 2
    t.integer  "currency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "diagnostic",                                         :default => false
    t.string   "code"
    t.integer  "score",                                              :default => 0
    t.integer  "activity_category_id"
  end

  create_table "activity_categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "complects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "complects_orders", :id => false, :force => true do |t|
    t.integer "order_id"
    t.integer "complect_id"
  end

  add_index "complects_orders", ["complect_id", "order_id"], :name => "index_complects_orders_on_complect_id_and_order_id", :unique => true

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

  create_table "defects_orders", :id => false, :force => true do |t|
    t.integer "defect_id"
    t.integer "order_id"
  end

  add_index "defects_orders", ["defect_id", "order_id"], :name => "index_defects_orders_on_defect_id_and_order_id", :unique => true

  create_table "exchange_jobs", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "target_path"
    t.datetime "latest_run"
    t.boolean  "success"
    t.string   "message"
    t.string   "value"
    t.time     "run_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "external_states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "external_states_orders", :id => false, :force => true do |t|
    t.integer "external_state_id"
    t.integer "order_id"
  end

  add_index "external_states_orders", ["external_state_id", "order_id"], :name => "index_external_states_orders_on_external_state_id_and_order_id", :unique => true

  create_table "goals", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goals_orders", :id => false, :force => true do |t|
    t.integer "goal_id"
    t.integer "order_id"
  end

  add_index "goals_orders", ["goal_id", "order_id"], :name => "index_goals_orders_on_goal_id_and_order_id", :unique => true

  create_table "grounds", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grounds_orders", :id => false, :force => true do |t|
    t.integer "ground_id"
    t.integer "order_id"
  end

  add_index "grounds_orders", ["ground_id", "order_id"], :name => "index_grounds_orders_on_ground_id_and_order_id", :unique => true

  create_table "internal_states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "internal_states_orders", :id => false, :force => true do |t|
    t.integer "internal_state_id"
    t.integer "order_id"
  end

  add_index "internal_states_orders", ["internal_state_id", "order_id"], :name => "index_internal_states_orders_on_internal_state_id_and_order_id", :unique => true

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "numerators", :force => true do |t|
    t.string  "name",                          :null => false
    t.integer "repair_type_id"
    t.integer "current_value",  :default => 0
  end

  create_table "order_activities", :force => true do |t|
    t.integer  "order_id"
    t.integer  "activity_id"
    t.date     "performed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.float    "price"
    t.integer  "currency_id"
  end

  add_index "order_activities", ["order_id", "activity_id"], :name => "index_order_activities_on_order_id_and_activity_id", :unique => true

  create_table "order_spare_parts", :force => true do |t|
    t.integer  "order_id"
    t.integer  "spare_part_id"
    t.integer  "currency_id"
    t.decimal  "price",         :precision => 9, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",                                    :default => 1, :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "number"
    t.integer  "ticket"
    t.text     "diag_result"
    t.text     "diag_ground"
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
    t.integer  "repair_type_id"
    t.integer  "reason_id"
    t.integer  "status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_passport_id"
    t.text     "result"
    t.text     "actual_defect"
    t.integer  "engineer_id"
    t.integer  "organization_id"
    t.integer  "created_from_id"
    t.integer  "diagnostic_activity_id"
    t.text     "external_state_note"
    t.boolean  "service_phone_agreement",                               :default => false
    t.text     "defect_note"
    t.integer  "location_id"
    t.text     "internal_state_note"
  end

  add_index "orders", ["created_from_id"], :name => "index_orders_on_created_from_id"
  add_index "orders", ["diagnostic_activity_id"], :name => "index_orders_on_diagnostic_activity_id"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "address"
    t.string   "working_time"
    t.string   "phone"
    t.integer  "responsible_id"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
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
    t.integer  "organization_id"
    t.integer  "position_id"
    t.integer  "person_status_id"
  end

  add_index "people", ["reset_password_token"], :name => "index_people_on_reset_password_token", :unique => true
  add_index "people", ["username"], :name => "index_people_on_username", :unique => true

  create_table "person_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "prevent_sign_in", :default => false
  end

  create_table "positions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "roles",      :default => "--- []\n"
  end

  create_table "prices", :force => true do |t|
    t.float    "value"
    t.integer  "priceable_id"
    t.string   "priceable_type"
    t.integer  "currency_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "producers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_passports", :force => true do |t|
    t.integer  "producer_id"
    t.integer  "product_id"
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

  create_table "repair_types_reports", :id => false, :force => true do |t|
    t.integer "repair_type_id", :null => false
    t.integer "report_id",      :null => false
  end

  add_index "repair_types_reports", ["repair_type_id", "report_id"], :name => "index_repair_types_reports_on_repair_type_id_and_report_id", :unique => true

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

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "spare_parts", :force => true do |t|
    t.string   "name"
    t.string   "part_number"
    t.decimal  "price",       :precision => 9, :scale => 2
    t.integer  "currency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spare_parts", ["part_number"], :name => "index_spare_parts_on_part_number", :unique => true

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer_info"
    t.boolean  "complete",      :default => false
    t.boolean  "ready",         :default => false
    t.boolean  "performed",     :default => false
  end

end
