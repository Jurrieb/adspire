# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20121212101753) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "clicks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.string   "referer"
    t.string   "ip_client"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "datafeed_keys", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "field_id"
    t.integer  "feed_id"
  end

  create_table "feeds", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "xml_path"
    t.string   "feed_path"
    t.string   "url"
    t.string   "status"
    t.integer  "user_id"
    t.integer  "interval_in_seconds"
    t.datetime "last_parse"
  end

  create_table "fields", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.boolean  "visible"
    t.string   "product_column_name"
  end

  create_table "filteroptions", :force => true do |t|
    t.integer  "filter_id"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "filters", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "foreign_categories", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "feed_id"
  end

  create_table "leads", :force => true do |t|
    t.integer  "click_id"
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notices", :force => true do |t|
    t.boolean  "lead"
    t.boolean  "sale"
    t.boolean  "feed"
    t.boolean  "result"
    t.boolean  "status"
    t.boolean  "merchant"
    t.boolean  "action"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.integer  "feed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "category_id"
    t.string   "url"
    t.string   "description"
    t.string   "image"
    t.decimal  "price"
    t.integer  "unique_hash"
    t.integer  "status"
    t.decimal  "price_old"
    t.integer  "user_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sites", :force => true do |t|
    t.integer  "user_id"
    t.text     "url"
    t.text     "description"
    t.integer  "category_id"
    t.boolean  "active"
    t.integer  "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
  end

  create_table "uploads", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "lastname"
    t.string   "phone"
    t.string   "organisation"
    t.text     "website"
    t.text     "comment"
    t.string   "street"
    t.integer  "housenumber"
    t.string   "zip"
    t.string   "place"
    t.string   "btw"
    t.string   "kvk"
    t.string   "company_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

end
