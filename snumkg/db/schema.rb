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

ActiveRecord::Schema.define(:version => 20120731113003) do

  create_table "alarms", :force => true do |t|
    t.integer  "article_id"
    t.integer  "comment_id"
    t.integer  "acceptor_id"
    t.integer  "alarmer_id"
    t.integer  "alarm_type"
    t.boolean  "new",         :default => true
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "articles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "board_id"
    t.string   "title"
    t.text     "body"
    t.integer  "view_count",   :default => 0
    t.string   "date"
    t.integer  "article_type", :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "attendances", :force => true do |t|
    t.integer  "user_id"
    t.integer  "article_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "boards", :force => true do |t|
    t.integer  "group_id"
    t.string   "name"
    t.integer  "admin_id"
    t.integer  "board_type", :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "article_id"
    t.integer  "user_id"
    t.integer  "profile_user_id"
    t.string   "content"
    t.integer  "comment_type",    :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "admin_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "article_id"
    t.integer  "comment_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "nickname"
    t.string   "phone_number"
    t.string   "department"
    t.integer  "grade"
    t.string   "email"
    t.integer  "alarm_counts",           :default => 0
    t.integer  "level",                  :default => 1
    t.string   "profile_url"
    t.boolean  "admin",                  :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "is_phone_number_public", :default => true
  end

end
