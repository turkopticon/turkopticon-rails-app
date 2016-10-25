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

ActiveRecord::Schema.define(version: 20160501145056) do

  create_table "aliases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "requester_id"
    t.integer  "formerly"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "report_id"
    t.integer  "person_id"
    t.text "body", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "notes", limit: 65535
    t.text "displayed_notes", limit: 65535
  end

  create_table "flags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "report_id"
    t.integer  "person_id"
    t.text "comment", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "displayed_notes", limit: 65535
  end

  create_table "follows", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id"
    t.string   "follow_type"
    t.integer  "follow_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_person_info", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id"
    t.decimal "karma", precision: 5, scale: 2
    t.string   "mail_forum_notifications"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_post_versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "post_id"
    t.string   "ip"
    t.text "title", limit: 65535
    t.text "body", limit: 65535
    t.integer  "next"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
  end

  create_table "forum_posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id"
    t.integer  "parent_id"
    t.string   "slug"
    t.boolean  "sticky"
    t.decimal "score", precision: 5, scale: 2
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
    t.decimal "initial_score", precision: 5, scale: 2
  end

  create_table "ignores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id"
    t.integer  "report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id"
    t.text "title", limit: 65535
    t.text "body", limit: 65535
    t.boolean  "read"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.integer  "commenting_enabled_by"
    t.datetime "commenting_enabled_at"
    t.integer  "commenting_disabled_by"
    t.datetime "commenting_disabled_at"
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id"
    t.integer  "parent_id"
    t.text "title", limit: 65535
    t.text "body", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.boolean  "is_sticky"
  end

  create_table "reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id"
    t.integer  "requester_id"
    t.string   "hit_id"
    t.text "description", limit: 65535
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
    t.text "displayed_notes", limit: 65535
    t.string   "amzn_requester_name"
    t.integer  "flag_count"
    t.integer  "comment_count"
    t.string   "ip"
    t.integer "ignore_count", default: 0
    t.text "hit_names", limit: 65535
    t.boolean  "dont_censor"
    t.string   "rejected"
  end

  create_table "reputation_statements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id"
    t.integer  "post_id"
    t.string   "statement"
    t.decimal "effect", precision: 3, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip"
  end

  create_table "requesters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "amzn_requester_id"
    t.string   "amzn_requester_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "ava", precision: 3, scale: 2
    t.integer  "nrs"
    t.decimal "av_comm", precision: 3, scale: 2
    t.decimal "av_pay", precision: 3, scale: 2
    t.decimal "av_fair", precision: 3, scale: 2
    t.decimal "av_fast", precision: 3, scale: 2
    t.integer  "tos_flags"
    t.string   "old_name"
    t.integer  "all_rejected"
    t.integer  "some_rejected"
    t.integer  "all_approved_or_pending"
    t.integer  "all_pending_or_didnt_do_hits"
  end

  create_table "rules_versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "parent_id"
    t.boolean  "is_current"
    t.integer  "edited_by_person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "body", limit: 65535
  end

end
