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

ActiveRecord::Schema.define(version: 20180212180557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.integer "user_id"
    t.integer "lecture_id"
    t.integer "condition"
    t.integer "course_id"
  end

  create_table "badges", force: :cascade do |t|
    t.string  "name"
    t.string  "description"
    t.string  "slug"
    t.integer "course_id"
  end

  create_table "checkpoints", force: :cascade do |t|
    t.string  "name"
    t.string  "link"
    t.date    "due_date"
    t.integer "course_id"
  end

  create_table "checks", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "checkpoint_id"
    t.text     "comments"
    t.integer  "condition"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "course_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "mood",         default: 0
    t.integer  "user_id"
    t.integer  "commenter_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "earnings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "badge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id"
  end

  create_table "events", force: :cascade do |t|
    t.string  "name"
    t.string  "description"
    t.integer "batch_size"
    t.integer "points_per_batch"
    t.integer "course_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string  "name"
    t.string  "url"
    t.text    "notes"
    t.integer "course_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "image"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "lectures", force: :cascade do |t|
    t.date    "date"
    t.string  "summary"
    t.integer "course_id"
  end

  create_table "measurements", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "reading_id"
    t.integer  "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.integer  "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "points",     default: 0
  end

  create_table "occurrences", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id"
  end

  create_table "readings", force: :cascade do |t|
    t.string  "name"
    t.string  "description"
    t.string  "slug"
    t.integer "course_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.integer  "exercise_id"
    t.datetime "finished_at"
    t.text     "notes"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "course_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

  create_table "teams", force: :cascade do |t|
    t.string  "name"
    t.string  "nickname"
    t.string  "image"
    t.integer "course_id"
  end

  create_table "timers", force: :cascade do |t|
    t.integer  "solution_id"
    t.integer  "stage"
    t.string   "sub_stage"
    t.integer  "total_time_in_seconds"
    t.integer  "estimated_time_in_seconds"
    t.datetime "started_at"
    t.string   "description"
    t.integer  "course_id"
  end

  create_table "user_solutions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "solution_id"
    t.integer "course_id"
  end

  create_table "user_tags", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tag_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "image"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "team_id"
    t.boolean  "locked",          default: false
    t.boolean  "enabled",         default: true
    t.string   "secondary_image"
  end

end
