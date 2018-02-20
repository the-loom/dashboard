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

ActiveRecord::Schema.define(version: 20180220140626) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.integer "user_id"
    t.integer "lecture_id"
    t.integer "condition"
    t.integer "course_id"
  end

  create_table "automatic_correction_issues", force: :cascade do |t|
    t.string  "issue_type"
    t.string  "message"
    t.string  "details"
    t.string  "payload"
    t.integer "automatic_correction_result_id"
    t.integer "course_id"
    t.index ["automatic_correction_result_id"], name: "ac_issues_index", using: :btree
  end

  create_table "automatic_correction_repos", force: :cascade do |t|
    t.string   "user"
    t.string   "name"
    t.string   "git_url"
    t.string   "avatar_url"
    t.string   "description"
    t.integer  "parent_id"
    t.integer  "author_id"
    t.boolean  "pending",     default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "difficulty"
    t.integer  "course_id"
  end

  create_table "automatic_correction_results", force: :cascade do |t|
    t.string  "test_type"
    t.decimal "score",                            precision: 4, scale: 2
    t.integer "automatic_correction_test_run_id"
    t.integer "course_id"
    t.index ["automatic_correction_test_run_id"], name: "ac_results_index", using: :btree
  end

  create_table "automatic_correction_test_runs", force: :cascade do |t|
    t.decimal  "score",                        precision: 4, scale: 2
    t.string   "git_commit_id"
    t.integer  "automatic_correction_repo_id"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.text     "details"
    t.integer  "course_id"
    t.index ["automatic_correction_repo_id"], name: "ac_test_runs_index", using: :btree
  end

  create_table "badges", force: :cascade do |t|
    t.string  "name"
    t.string  "description"
    t.string  "slug"
    t.integer "course_id"
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

  create_table "memberships", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.integer  "role"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "points",               default: 0
    t.integer  "unread_notifications", default: 0
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "subject"
    t.text     "text"
    t.string   "author"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_notifications_on_course_id", using: :btree
  end

  create_table "occurrences", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.integer  "exercise_id"
    t.datetime "finished_at"
    t.text     "notes"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "course_id"
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

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "image"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "team_id"
    t.boolean  "locked",     default: false
    t.boolean  "enabled",    default: true
  end

  add_foreign_key "automatic_correction_repos", "automatic_correction_repos", column: "parent_id"
end
