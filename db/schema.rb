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

ActiveRecord::Schema.define(version: 20170125103407) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aliases", force: :cascade do |t|
    t.integer  "requester_id"
    t.integer  "formerly"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "review_id"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "public_comments_person_id0_idx", using: :btree
    t.index ["review_id"], name: "public_comments_review_id1_idx", using: :btree
  end

  create_table "flags", force: :cascade do |t|
    t.string "reason"
    t.text "context"
    t.integer  "person_id"
    t.integer "review_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_flags_on_person_id", using: :btree
    t.index ["review_id"], name: "index_flags_on_review_id", using: :btree
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "person_id"
    t.string "follow_type", limit: 255
    t.integer  "follow_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_person_info", force: :cascade do |t|
    t.integer  "person_id"
    t.decimal "karma", precision: 5, scale: 2
    t.string "mail_forum_notifications", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_post_versions", force: :cascade do |t|
    t.integer  "post_id"
    t.string "ip", limit: 255
    t.text "title"
    t.text "body"
    t.integer  "next"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
  end

  create_table "forum_posts", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "parent_id"
    t.string "slug", limit: 255
    t.integer "sticky", limit: 2
    t.decimal "score", precision: 5, scale: 2
    t.integer  "replies"
    t.integer  "views"
    t.string "last_reply_display_name", limit: 255
    t.string "last_reply_person_id", limit: 255
    t.integer  "last_reply_id"
    t.datetime "last_reply_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "thread_head"
    t.integer "deleted", limit: 2
    t.decimal "initial_score", precision: 5, scale: 2
  end

  create_table "hits", force: :cascade do |t|
    t.string "title", limit: 255
    t.decimal "reward", precision: 6, scale: 2
    t.integer "requester_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["requester_id"], name: "public_hits_requester_id0_idx", using: :btree
    t.index ["title"], name: "public_hits_title1_idx", using: :btree
  end

  create_table "ignores", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "legacy_comments", force: :cascade do |t|
    t.integer "report_id"
    t.integer "person_id"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "notes"
    t.text "displayed_notes"
  end

  create_table "legacy_flags", force: :cascade do |t|
    t.integer "report_id"
    t.integer "person_id"
    t.text "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "displayed_notes"
  end

  create_table "legacy_requesters", force: :cascade do |t|
    t.string "amzn_requester_id", limit: 255
    t.string "amzn_requester_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "ava", precision: 3, scale: 2
    t.integer "nrs"
    t.decimal "av_comm", precision: 3, scale: 2
    t.decimal "av_pay", precision: 3, scale: 2
    t.decimal "av_fair", precision: 3, scale: 2
    t.decimal "av_fast", precision: 3, scale: 2
    t.integer "tos_flags"
    t.string "old_name", limit: 255
    t.integer "all_rejected"
    t.integer "some_rejected"
    t.integer "all_approved_or_pending"
    t.integer "all_pending_or_didnt_do_hits"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "person_id"
    t.text "title"
    t.text "body"
    t.integer "read", limit: 2
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: :cascade do |t|
    t.string "email", limit: 255
    t.string "hashed_password", limit: 255
    t.string "salt", limit: 255
    t.integer "email_verified", limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "is_admin", limit: 2
    t.string "display_name", limit: 255
    t.integer "is_moderator", limit: 2
    t.integer "is_closed", limit: 2
    t.datetime "closed_at"
    t.integer "most_recent_first_in_my_reviews", limit: 2
    t.integer "can_comment", limit: 2
    t.integer "commenting_requested", limit: 2
    t.datetime "commenting_requested_at"
    t.integer "commenting_request_ignored", limit: 2
    t.integer "order_reviews_by_edit_date", limit: 2
    t.integer "show_fancy_links", limit: 2
    t.integer  "commenting_enabled_by"
    t.datetime "commenting_enabled_at"
    t.integer  "commenting_disabled_by"
    t.datetime "commenting_disabled_at"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "parent_id"
    t.text "title"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug", limit: 255
    t.integer "is_sticky", limit: 2
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "requester_id"
    t.string "hit_id", limit: 255
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "how_many_hits", limit: 255
    t.integer  "fair"
    t.integer  "fast"
    t.integer  "pay"
    t.integer  "comm"
    t.integer "is_flagged", limit: 2
    t.integer "is_hidden", limit: 2
    t.integer "tos_viol", limit: 2
    t.string "amzn_requester_id", limit: 255
    t.text "displayed_notes"
    t.string "amzn_requester_name", limit: 255
    t.integer  "flag_count"
    t.integer  "comment_count"
    t.string "ip", limit: 255
    t.integer "ignore_count", default: 0
    t.text "hit_names"
    t.integer "dont_censor", limit: 2
    t.string "rejected", limit: 255
  end

  create_table "reputation_statements", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "post_id"
    t.string "statement", limit: 255
    t.decimal "effect", precision: 3, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "ip", limit: 255
  end

  create_table "requesters", force: :cascade do |t|
    t.string "rname", limit: 255
    t.string "rid", limit: 255
    t.text "aliases"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rid"], name: "public_requesters_rid0_idx", using: :btree
    t.index ["rname"], name: "public_requesters_rname1_idx", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "tos", limit: 2
    t.text "tos_context"
    t.integer "broken", limit: 2
    t.text "broken_context"
    t.decimal "reward", precision: 6, scale: 2
    t.integer "time"
    t.string "comm", limit: 255
    t.integer "time_pending"
    t.string "rejected", limit: 255
    t.string "recommend", limit: 255
    t.text "recommend_context"
    t.text "context"
    t.integer "valid_review", limit: 2, default: 1, null: false
    t.integer "hit_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hit_id"], name: "public_reviews_hit_id0_idx", using: :btree
    t.index ["person_id"], name: "public_reviews_person_id1_idx", using: :btree
  end

  create_table "rules_versions", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer "is_current", limit: 2
    t.integer  "edited_by_person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "body"
  end

  add_foreign_key "comments", "people", name: "comments_person_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "comments", "reviews", name: "comments_review_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "flags", "people"
  add_foreign_key "flags", "reviews"
  add_foreign_key "hits", "requesters", name: "hits_requester_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "reviews", "hits", name: "reviews_hit_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "reviews", "people", name: "reviews_person_id_fkey", on_update: :restrict, on_delete: :restrict
end
