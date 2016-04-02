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

ActiveRecord::Schema.define(:version => 20160402221950) do

  create_table "Dolores_A2IR8TEVONNLZO", :id => false, :force => true do |t|
    t.integer  "id",            :default => 0, :null => false
    t.integer  "person_id"
    t.integer  "requester_id"
    t.string   "hit_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "how_many_hits"
    t.integer  "fair"
    t.integer  "fast"
    t.integer  "pay"
    t.integer  "comm"
  end

  create_table "aliases", :force => true do |t|
    t.integer  "requester_id"
    t.integer  "formerly"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "report_id"
    t.integer  "person_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.text     "displayed_notes"
  end

  create_table "comments_purgatory", :id => false, :force => true do |t|
    t.integer  "id",         :default => 0, :null => false
    t.integer  "report_id"
    t.integer  "person_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flags", :force => true do |t|
    t.integer  "report_id"
    t.integer  "person_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "displayed_notes"
  end

  create_table "flags_purgatory", :id => false, :force => true do |t|
    t.integer  "id",         :default => 0, :null => false
    t.integer  "report_id"
    t.integer  "person_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", :force => true do |t|
    t.integer  "person_id"
    t.string   "follow_type"
    t.integer  "follow_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_person_info", :force => true do |t|
    t.integer  "person_id"
    t.decimal  "karma",                    :precision => 5, :scale => 2
    t.string   "mail_forum_notifications"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_post_versions", :force => true do |t|
    t.integer  "post_id"
    t.string   "ip"
    t.text     "title"
    t.text     "body"
    t.integer  "next"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
  end

  create_table "forum_posts", :force => true do |t|
    t.integer  "person_id"
    t.integer  "parent_id"
    t.string   "slug"
    t.boolean  "sticky"
    t.decimal  "score",                   :precision => 5, :scale => 2
    t.integer  "replies"
    t.integer  "views"
    t.string   "last_reply_display_name"
    t.string   "last_reply_person_id"
    t.integer  "last_reply_id"
    t.datetime "last_reply_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "thread_head"
    t.boolean  "deleted"
    t.decimal  "initial_score",           :precision => 5, :scale => 2
  end

  create_table "ignores", :force => true do |t|
    t.integer  "person_id"
    t.integer  "report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "person_id"
    t.text     "title"
    t.text     "body"
    t.boolean  "read"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.string   "salt"
    t.boolean  "email_verified"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin"
    t.string   "display_name"
    t.boolean  "is_moderator"
    t.boolean  "is_closed"
    t.datetime "closed_at"
    t.boolean  "most_recent_first_in_my_reviews"
    t.boolean  "can_comment"
    t.boolean  "commenting_requested"
    t.datetime "commenting_requested_at"
    t.boolean  "commenting_request_ignored"
    t.boolean  "order_reviews_by_edit_date"
    t.boolean  "show_fancy_links"
  end

  create_table "posts", :force => true do |t|
    t.integer  "person_id"
    t.integer  "parent_id"
    t.text     "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.boolean  "is_sticky"
  end

  create_table "report_outliers", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "requester_id"
    t.integer "fair"
  end

  create_table "report_statistics", :id => false, :force => true do |t|
    t.integer "person_id"
    t.decimal "mu",                      :precision => 14, :scale => 4
    t.float   "sigma",     :limit => 26
  end

  create_table "reports", :force => true do |t|
    t.integer  "person_id"
    t.integer  "requester_id"
    t.string   "hit_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "how_many_hits"
    t.integer  "fair"
    t.integer  "fast"
    t.integer  "pay"
    t.integer  "comm"
    t.boolean  "is_flagged"
    t.boolean  "is_hidden"
    t.boolean  "tos_viol"
    t.string   "amzn_requester_id"
    t.text     "displayed_notes"
    t.string   "amzn_requester_name"
    t.integer  "flag_count"
    t.integer  "comment_count"
    t.string   "ip"
    t.integer  "ignore_count",        :default => 0
    t.text     "hit_names"
    t.boolean  "dont_censor"
    t.string   "rejected"
  end

  add_index "reports", ["amzn_requester_name"], :name => "reports_requester_name_index"

  create_table "reports_purgatory", :id => false, :force => true do |t|
    t.integer  "id",            :default => 0, :null => false
    t.integer  "person_id"
    t.integer  "requester_id"
    t.string   "hit_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "how_many_hits"
    t.integer  "fair"
    t.integer  "fast"
    t.integer  "pay"
    t.integer  "comm"
  end

  create_table "reputation_statements", :force => true do |t|
    t.integer  "person_id"
    t.integer  "post_id"
    t.string   "statement"
    t.decimal  "effect",     :precision => 3, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip"
  end

  create_table "requester_outliers", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "requester_id"
    t.integer "fair"
  end

  create_table "requester_statistics", :id => false, :force => true do |t|
    t.integer "requester_id"
    t.decimal "mu",                         :precision => 14, :scale => 4
    t.float   "sigma",        :limit => 26
  end

  create_table "requesters", :force => true do |t|
    t.string   "amzn_requester_id"
    t.string   "amzn_requester_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "ava",                 :precision => 3, :scale => 2
    t.integer  "nrs"
    t.decimal  "av_comm",             :precision => 3, :scale => 2
    t.decimal  "av_pay",              :precision => 3, :scale => 2
    t.decimal  "av_fair",             :precision => 3, :scale => 2
    t.decimal  "av_fast",             :precision => 3, :scale => 2
    t.integer  "tos_flags"
    t.string   "old_name"
  end

end
