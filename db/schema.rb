# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_28_231130) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "automatic_correction_issues", id: :serial, force: :cascade do |t|
    t.string "issue_type"
    t.string "message"
    t.string "details"
    t.string "payload"
    t.integer "automatic_correction_result_id"
    t.integer "course_id"
    t.index ["automatic_correction_result_id"], name: "ac_issues_index"
  end

  create_table "automatic_correction_repos", id: :serial, force: :cascade do |t|
    t.integer "author_id"
    t.string "user"
    t.string "name"
    t.string "git_url"
    t.string "avatar_url"
    t.string "description"
    t.integer "parent_id"
    t.boolean "pending", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "difficulty"
    t.integer "course_id"
    t.boolean "published", default: true
  end

  create_table "automatic_correction_results", id: :serial, force: :cascade do |t|
    t.string "test_type"
    t.decimal "score", precision: 4, scale: 2
    t.integer "automatic_correction_test_run_id"
    t.integer "course_id"
    t.index ["automatic_correction_test_run_id"], name: "ac_results_index"
  end

  create_table "automatic_correction_test_runs", id: :serial, force: :cascade do |t|
    t.decimal "score", precision: 4, scale: 2
    t.string "git_commit_id"
    t.integer "automatic_correction_repo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "details"
    t.integer "course_id"
    t.index ["automatic_correction_repo_id"], name: "ac_test_runs_index"
  end

  create_table "badges", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "course_id"
    t.boolean "featured", default: false
  end

  create_table "certificates", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_certificates_on_user_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.integer "commenter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
  end

  create_table "competence_tags", force: :cascade do |t|
    t.string "name"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true
    t.datetime "discarded_at"
    t.integer "features", default: 0
    t.string "password"
    t.integer "attendance_event_id"
    t.string "stats"
    t.integer "parent_course_id"
    t.boolean "replica", default: false
    t.boolean "registrable", default: true
    t.index ["discarded_at"], name: "index_courses_on_discarded_at"
  end

  create_table "courses_tiny_cards_decks", force: :cascade do |t|
    t.integer "course_id"
    t.integer "deck_id"
  end

  create_table "earnings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "badge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "points"
    t.integer "course_id"
    t.integer "min_points"
    t.integer "max_points"
    t.integer "competence_tag_id"
    t.boolean "enabled", default: true
  end

  create_table "exercises", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "notes"
    t.integer "course_id"
    t.boolean "published", default: true
    t.integer "difficulty", default: 1
    t.date "start_date"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_exercises_on_discarded_at"
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question"
    t.text "answer"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identities", id: :serial, force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "first_name"
    t.string "nickname"
    t.string "email"
    t.string "image"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_name"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "lectures", id: :serial, force: :cascade do |t|
    t.date "date"
    t.string "summary"
    t.integer "course_id"
    t.boolean "required", default: true
    t.time "time_from"
    t.time "time_to"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_lectures_on_discarded_at"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.integer "user_id"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unread_notifications", default: 0
    t.boolean "enabled", default: true
    t.integer "team_id"
    t.datetime "discarded_at"
    t.string "present_at_lecture_ids"
    t.integer "points", default: 0
    t.string "stats"
    t.index ["discarded_at"], name: "index_memberships_on_discarded_at"
  end

  create_table "multiple_choices_answers", force: :cascade do |t|
    t.string "text"
    t.boolean "correct"
    t.string "explanation"
    t.integer "multiple_choices_question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "multiple_choices_questionnaires", force: :cascade do |t|
    t.string "name"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: true
    t.boolean "enabled", default: false
    t.boolean "single_use", default: false
  end

  create_table "multiple_choices_questions", force: :cascade do |t|
    t.string "wording"
    t.integer "multiple_choices_questionnaire_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden", default: false
  end

  create_table "multiple_choices_responses", force: :cascade do |t|
    t.integer "multiple_choices_solution_id"
    t.integer "multiple_choices_question_id"
    t.integer "multiple_choices_answer_id"
    t.boolean "correct", default: false
  end

  create_table "multiple_choices_solutions", force: :cascade do |t|
    t.integer "course_id"
    t.integer "multiple_choices_questionnaire_id"
    t.integer "user_id"
    t.decimal "score", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.string "subject"
    t.text "text"
    t.string "author"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "receiver_id"
    t.index ["course_id"], name: "index_notifications_on_course_id"
    t.index ["receiver_id"], name: "index_notifications_on_receiver_id"
  end

  create_table "occurrences", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
    t.integer "multiplier", default: 1
  end

  create_table "peer_review_challenges", force: :cascade do |t|
    t.string "title"
    t.integer "difficulty", default: 1
    t.string "instructions"
    t.string "reviewer_instructions"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true
    t.boolean "published", default: false
    t.integer "challenge_mode", default: 0
    t.date "due_date"
    t.boolean "allows_attachment", default: false
    t.integer "expected_reviews", default: 1
    t.boolean "team_challenge", default: false
    t.string "language"
    t.integer "solution_type", default: 0
    t.boolean "allows_quick_reviews", default: false
    t.boolean "awarded", default: false
    t.boolean "optional", default: false
    t.string "rubrics"
    t.date "start_date"
  end

  create_table "peer_review_messages", force: :cascade do |t|
    t.text "content"
    t.integer "peer_review_review_id"
    t.integer "user_id"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "peer_review_reviews", force: :cascade do |t|
    t.string "wording"
    t.integer "status", default: 0
    t.integer "peer_review_solution_id"
    t.integer "reviewer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
    t.string "rubrics"
  end

  create_table "peer_review_solutions", force: :cascade do |t|
    t.string "wording"
    t.integer "status", default: 0
    t.integer "peer_review_challenge_id"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "picked", default: false
    t.integer "course_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "text"
    t.boolean "pinned", default: false
    t.bigint "author_id"
    t.bigint "notification_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["course_id"], name: "index_posts_on_course_id"
    t.index ["notification_id"], name: "index_posts_on_notification_id"
  end

  create_table "resource_categories", force: :cascade do |t|
    t.string "name"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string "url"
    t.string "title"
    t.string "description"
    t.integer "resource_category_id"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suggestions", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "suggestion_type"
    t.integer "course_id"
    t.integer "author_id"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "done", default: false
    t.index ["discarded_at"], name: "index_suggestions_on_discarded_at"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "nickname"
    t.integer "course_id"
    t.string "stats"
    t.integer "points", default: 0
  end

  create_table "tiny_cards_cards", force: :cascade do |t|
    t.string "front"
    t.string "back"
    t.integer "tiny_cards_deck_id"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tiny_cards_decks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "nickname"
    t.string "email"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.string "last_name"
    t.boolean "admin", default: false
    t.datetime "discarded_at"
    t.integer "last_visited_course_id", default: 0
    t.string "bios"
    t.string "alternative_id"
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "automatic_correction_repos", "automatic_correction_repos", column: "parent_id"
  add_foreign_key "courses", "courses", column: "parent_course_id"
  add_foreign_key "notifications", "users", column: "receiver_id"
  add_foreign_key "posts", "users", column: "author_id"
  add_foreign_key "taggings", "tags"
end
