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

ActiveRecord::Schema.define(:version => 20130117084009) do

  create_table "alarm_groups", :force => true do |t|
    t.integer  "article_id"
    t.integer  "comment_id"
    t.string   "alarm_type"
    t.integer  "accepter_id"
    t.integer  "state",        :default => 0
    t.datetime "refreshed_at"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "alarms", :force => true do |t|
    t.integer  "alarm_group_id"
    t.integer  "alarmer_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "articles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "board_id"
    t.string   "title"
    t.text     "body"
    t.integer  "number"
    t.integer  "view_count",     :default => 0
    t.boolean  "is_notice",      :default => false
    t.string   "article_type"
    t.datetime "date"
    t.string   "anonymous_name"
    t.string   "password_salt"
    t.string   "password_hash"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
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
    t.string   "board_type",    :default => "일반"
    t.boolean  "is_hidden",     :default => false
    t.integer  "position",      :default => 0
    t.integer  "article_count", :default => 1
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "article_id"
    t.integer  "user_id"
    t.integer  "profile_user_id"
    t.string   "content"
    t.string   "anonymous_name"
    t.string   "password_salt"
    t.string   "password_hash"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "admin_id"
    t.boolean  "is_hidden",  :default => false
    t.string   "group_type"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "article_id"
    t.integer  "comment_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "title"
    t.text     "content"
    t.boolean  "is_read",     :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "newsfeeds", :force => true do |t|
    t.integer  "comment_id"
    t.integer  "article_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "options", :force => true do |t|
    t.string   "content"
    t.integer  "poll_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pictures", :force => true do |t|
    t.string   "full_path"
    t.string   "size"
    t.string   "url"
    t.string   "name"
    t.string   "thumb_path"
    t.string   "thumb_url"
    t.integer  "article_id"
    t.string   "main_thumb_path"
    t.string   "main_thumb_url"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "polls", :force => true do |t|
    t.string   "title"
    t.integer  "article_id"
    t.string   "poll_type"
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
    t.boolean  "is_phone_number_public",   :default => true
    t.string   "department"
    t.string   "entrance_year"
    t.string   "email"
    t.date     "birthday"
    t.integer  "alarm_counts",             :default => 0
    t.integer  "level",                    :default => 1
    t.string   "profile_image_path"
    t.string   "profile_image_thumb_path"
    t.boolean  "is_admin",                 :default => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.integer  "option_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
