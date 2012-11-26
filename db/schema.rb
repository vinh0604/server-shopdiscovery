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

ActiveRecord::Schema.define(:version => 20121126161038) do

  create_table "categories", :force => true do |t|
    t.integer  "parent_id"
    t.string   "sequence"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "gender"
    t.datetime "birthdate"
    t.string   "phone"
    t.string   "address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "favorite_shops", :force => true do |t|
    t.integer  "shop_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "managers", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "owner"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "message_receivers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.string   "title"
    t.text     "content"
    t.datetime "sent_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.string   "source_type"
    t.integer  "source_id"
    t.integer  "type"
    t.text     "content"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "order_shipments", :force => true do |t|
    t.integer  "order_id"
    t.integer  "contact_id"
    t.datetime "ship_date"
    t.decimal  "fee"
    t.integer  "ship_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "shop_product_id"
    t.decimal  "price"
    t.integer  "amount"
    t.decimal  "tax"
    t.decimal  "total"
    t.integer  "status"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "image"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "products", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.string   "barcode"
    t.hstore   "specifics"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "products_tags", :force => true do |t|
    t.integer "tag_id"
    t.integer "product_id"
  end

  create_table "promotion_bidders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "promotion_id"
    t.integer  "amount"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "promotions", :force => true do |t|
    t.integer  "shop_product_id"
    t.decimal  "price"
    t.datetime "expires"
    t.datetime "active_date"
    t.integer  "amount"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "purchased_orders", :force => true do |t|
    t.integer  "order_id"
    t.integer  "contact_id"
    t.string   "po_number"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reviews", :force => true do |t|
    t.integer  "reviewer_id"
    t.string   "title"
    t.text     "content"
    t.integer  "rating"
    t.integer  "reviewable_id"
    t.string   "reviewable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "shop_products", :force => true do |t|
    t.integer  "product_id"
    t.integer  "shop_id"
    t.integer  "status"
    t.decimal  "price"
    t.integer  "warranty"
    t.integer  "origin"
    t.integer  "avaibility"
    t.text     "description"
    t.float    "avg_score"
    t.integer  "review_count"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "shops", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.text     "phones"
    t.string   "street_address"
    t.string   "district"
    t.string   "city"
    t.float    "avg_score"
    t.integer  "review_count"
    t.text     "description"
    t.integer  "creator_id"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.spatial  "location",       :limit => {:srid=>0, :type=>"point"}
  end

  create_table "shops_tags", :force => true do |t|
    t.integer "tag_id"
    t.integer "shop_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags_users", :force => true do |t|
    t.integer "tag_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "avatar"
    t.string   "username"
    t.integer  "contact_id"
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
    t.string   "password_salt"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "wish_lists", :force => true do |t|
    t.integer  "shop_product_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
