# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090624143703) do

  create_table "items", :force => true do |t|
    t.string   "title",                        :null => false
    t.text     "description"
    t.integer  "list_id",                      :null => false
    t.integer  "user_id",                      :null => false
    t.float    "mean",        :default => 0.0
    t.float    "std",         :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["list_id"], :name => "index_items_on_list_id"

  create_table "lists", :force => true do |t|
    t.string   "title",                             :null => false
    t.integer  "user_id",                           :null => false
    t.text     "description"
    t.integer  "items_count",    :default => 0
    t.integer  "comments_count", :default => 0
    t.integer  "rankings_count", :default => 0
    t.boolean  "is_private",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["user_id"], :name => "index_lists_on_user_id"

  create_table "rankings", :force => true do |t|
    t.integer  "list_id",    :null => false
    t.integer  "user_id"
    t.text     "ordinals",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rankings", ["list_id", "user_id"], :name => "index_rankings_on_list_id_and_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login",                            :null => false
    t.string   "email",                            :null => false
    t.string   "crypted_password",                 :null => false
    t.string   "password_salt",                    :null => false
    t.string   "persistence_token",                :null => false
    t.integer  "login_count",       :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
