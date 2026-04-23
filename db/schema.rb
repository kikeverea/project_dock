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

ActiveRecord::Schema[8.1].define(version: 2026_04_18_100012) do
  create_table "activities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date"
    t.string "name"
    t.bigint "project_id", null: false
    t.bigint "proposed_by_id"
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_activities_on_project_id"
    t.index ["proposed_by_id"], name: "index_activities_on_proposed_by_id"
  end

  create_table "clients", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "logo"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "documents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "documentable_id", null: false
    t.string "documentable_type", null: false
    t.string "file"
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "uploaded_by_id", null: false
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable"
    t.index ["uploaded_by_id"], name: "index_documents_on_uploaded_by_id"
  end

  create_table "emails", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.bigint "emailable_id", null: false
    t.string "emailable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["emailable_type", "emailable_id"], name: "index_emails_on_emailable"
  end

  create_table "interactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "parent_interaction_id"
    t.string "status"
    t.bigint "task_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["parent_interaction_id"], name: "index_interactions_on_parent_interaction_id"
    t.index ["task_id"], name: "index_interactions_on_task_id"
    t.index ["user_id"], name: "index_interactions_on_user_id"
  end

  create_table "logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.bigint "loggable_id", null: false
    t.string "loggable_type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["loggable_type", "loggable_id"], name: "index_logs_on_loggable"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "phone_numbers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "number"
    t.bigint "phoneable_id", null: false
    t.string "phoneable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["phoneable_type", "phoneable_id"], name: "index_phone_numbers_on_phoneable"
  end

  create_table "projects", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "allocated_time"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.integer "current_time"
    t.date "due_date"
    t.string "name"
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_projects_on_client_id"
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "tasks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "activity_id"
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.datetime "latest_status_at"
    t.string "status"
    t.string "task_type"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_tasks_on_activity_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "image"
    t.string "lastname"
    t.string "name"
    t.string "password_digest", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "activities", "projects"
  add_foreign_key "activities", "users", column: "proposed_by_id"
  add_foreign_key "documents", "users", column: "uploaded_by_id"
  add_foreign_key "interactions", "interactions", column: "parent_interaction_id"
  add_foreign_key "interactions", "tasks"
  add_foreign_key "interactions", "users"
  add_foreign_key "logs", "users"
  add_foreign_key "projects", "clients"
  add_foreign_key "sessions", "users"
  add_foreign_key "tasks", "activities"
end
