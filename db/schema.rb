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

ActiveRecord::Schema.define(version: 2020_02_24_081312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clusters", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hashed_password"
    t.datetime "password_updated_at"
    t.index ["name"], name: "index_clusters_on_name", unique: true
  end

  create_table "containers", force: :cascade do |t|
    t.integer "cluster_id", null: false
    t.string "hostname", null: false
    t.string "ipaddress"
    t.string "image_alias"
    t.integer "node_id"
    t.string "status", null: false
    t.datetime "last_status_update_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "source_id"
    t.jsonb "bootstrappers", default: [], null: false
    t.index ["cluster_id", "hostname"], name: "index_containers_on_cluster_id_and_hostname"
  end

  create_table "deployments", force: :cascade do |t|
    t.bigint "cluster_id", null: false
    t.string "name", null: false
    t.integer "count", default: 1, null: false
    t.jsonb "definition", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cluster_id", "name"], name: "index_deployments_on_cluster_id_and_name", unique: true
    t.index ["cluster_id"], name: "index_deployments_on_cluster_id"
  end

  create_table "ext_apps", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "user_id", null: false
    t.string "hashed_access_token", null: false
    t.datetime "access_token_generated_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashed_access_token"], name: "index_ext_apps_on_hashed_access_token"
    t.index ["name"], name: "index_ext_apps_on_name", unique: true
  end

  create_table "nodes", force: :cascade do |t|
    t.integer "cluster_id", null: false
    t.string "hostname", null: false
    t.string "ipaddress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hashed_authentication_token"
    t.datetime "authentication_token_generated_at"
    t.bigint "mem_free_mb"
    t.bigint "mem_used_mb"
    t.bigint "mem_total_mb"
    t.index ["hashed_authentication_token"], name: "index_nodes_on_hashed_authentication_token"
    t.index ["hostname"], name: "index_nodes_on_hostname", unique: true
  end

  create_table "remotes", force: :cascade do |t|
    t.string "name", null: false
    t.string "server"
    t.string "protocol", null: false
    t.string "auth_type", null: false
    t.text "certificate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_remotes_on_name", unique: true
  end

  create_table "sources", force: :cascade do |t|
    t.string "source_type", null: false
    t.string "mode", null: false
    t.integer "remote_id"
    t.string "fingerprint"
    t.string "alias"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alias"], name: "index_sources_on_alias"
    t.index ["fingerprint"], name: "index_sources_on_fingerprint"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "containers", "clusters"
  add_foreign_key "containers", "nodes"
  add_foreign_key "containers", "sources"
  add_foreign_key "ext_apps", "users"
  add_foreign_key "nodes", "clusters"
  add_foreign_key "sources", "remotes"
end
