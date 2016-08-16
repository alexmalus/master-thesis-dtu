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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160507163943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chatrooms", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  add_index "chatrooms", ["team_id"], name: "index_chatrooms_on_team_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "sprint_id"
    t.integer  "release_id"
    t.integer  "user_story_id"
    t.string   "file_id",           null: false
    t.string   "file_filename",     null: false
    t.string   "file_size",         null: false
    t.string   "file_content_type", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "documents", ["project_id"], name: "index_documents_on_project_id", using: :btree
  add_index "documents", ["release_id"], name: "index_documents_on_release_id", using: :btree
  add_index "documents", ["sprint_id"], name: "index_documents_on_sprint_id", using: :btree
  add_index "documents", ["user_story_id"], name: "index_documents_on_user_story_id", using: :btree

  create_table "epics", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "status"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "epics", ["project_id"], name: "index_epics_on_project_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "chatroom_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "messages", ["chatroom_id"], name: "index_messages_on_chatroom_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "product_backlogs", force: :cascade do |t|
    t.string   "category"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "product_backlogs", ["project_id"], name: "index_product_backlogs_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "name"
    t.string   "description"
    t.string   "image_id"
    t.string   "image_filename"
    t.integer  "image_size"
    t.string   "image_content_type"
    t.integer  "def_sprint_dur"
    t.boolean  "def_proj_tips"
    t.integer  "total_file_limit_size"
    t.boolean  "active"
    t.integer  "committed_work",        default: 0, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "projects", ["team_id"], name: "index_projects_on_team_id", using: :btree

  create_table "releases", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "status",      default: 0
    t.integer  "project_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "releases", ["project_id"], name: "index_releases_on_project_id", using: :btree

  create_table "retrospectives", force: :cascade do |t|
    t.string   "name"
    t.string   "description_good"
    t.string   "description_bad"
    t.string   "description_future"
    t.integer  "sprint_id"
    t.integer  "project_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "retrospectives", ["project_id"], name: "index_retrospectives_on_project_id", using: :btree
  add_index "retrospectives", ["sprint_id"], name: "index_retrospectives_on_sprint_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "sprint_backlogs", force: :cascade do |t|
    t.integer  "sprint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sprint_backlogs", ["sprint_id"], name: "index_sprint_backlogs_on_sprint_id", using: :btree

  create_table "sprint_done_works", force: :cascade do |t|
    t.integer  "sprint_id"
    t.integer  "project_id"
    t.integer  "committed_work"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "sprint_done_works", ["sprint_id"], name: "index_sprint_done_works_on_sprint_id", using: :btree

  create_table "sprints", force: :cascade do |t|
    t.integer  "release_id"
    t.integer  "project_id"
    t.string   "name"
    t.integer  "status",           default: 0
    t.integer  "committed_effort"
    t.integer  "done_effort"
    t.datetime "start_date"
    t.datetime "release_date"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "sprints", ["project_id"], name: "index_sprints_on_project_id", using: :btree
  add_index "sprints", ["release_id"], name: "index_sprints_on_release_id", using: :btree

  create_table "team_invitations", force: :cascade do |t|
    t.boolean  "is_active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "team_id"
    t.integer  "sender_id"
    t.integer  "receiver_id"
  end

  add_index "team_invitations", ["receiver_id"], name: "index_team_invitations_on_receiver_id", using: :btree
  add_index "team_invitations", ["sender_id"], name: "index_team_invitations_on_sender_id", using: :btree
  add_index "team_invitations", ["team_id"], name: "index_team_invitations_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "owner_id"
  end

  add_index "teams", ["owner_id"], name: "index_teams_on_owner_id", using: :btree

  create_table "teams_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
  end

  add_index "teams_users", ["user_id", "team_id"], name: "index_teams_users_on_user_id_and_team_id", using: :btree

  create_table "themes", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "status"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "themes", ["project_id"], name: "index_themes_on_project_id", using: :btree

  create_table "user_feedbacks", force: :cascade do |t|
    t.string   "name"
    t.string   "contact_info"
    t.string   "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "user_stories", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "acceptance_condition"
    t.integer  "priority"
    t.integer  "effort"
    t.integer  "status",               default: 0
    t.boolean  "is_task",              default: false
    t.datetime "finished_date"
    t.integer  "product_backlog_id"
    t.integer  "sprint_backlog_id"
    t.integer  "epic_id"
    t.integer  "theme_id"
    t.integer  "user_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "user_stories", ["epic_id"], name: "index_user_stories_on_epic_id", using: :btree
  add_index "user_stories", ["product_backlog_id"], name: "index_user_stories_on_product_backlog_id", using: :btree
  add_index "user_stories", ["sprint_backlog_id"], name: "index_user_stories_on_sprint_backlog_id", using: :btree
  add_index "user_stories", ["theme_id"], name: "index_user_stories_on_theme_id", using: :btree
  add_index "user_stories", ["user_id"], name: "index_user_stories_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "student_number"
    t.string   "phone_number"
    t.string   "skype"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "image_id"
    t.string   "image_filename"
    t.integer  "image_size"
    t.string   "image_content_type"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.integer  "invited_on_team_id"
    t.datetime "last_seen"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "chatrooms", "teams"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "messages", "users"
  add_foreign_key "team_invitations", "teams"
end
