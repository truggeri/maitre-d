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

ActiveRecord::Schema.define(version: 2021_10_18_215528) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "email_auths", force: :cascade do |t|
    t.bigint "patron_id", null: false
    t.string "email", limit: 255
    t.string "password_digest", limit: 255
    t.string "recovery_password_digest", limit: 255
    t.datetime "last_logged_in_at"
    t.index ["email"], name: "index_email_auths_on_email", unique: true
    t.index ["patron_id"], name: "index_email_auths_on_patron_id"
  end

  create_table "patrons", force: :cascade do |t|
    t.string "external_id", limit: 255, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_id"], name: "index_patrons_on_external_id", unique: true
  end

  create_table "patrons_roles", id: false, force: :cascade do |t|
    t.bigint "patron_id", null: false
    t.bigint "role_id", null: false
    t.index ["patron_id", "role_id"], name: "index_patrons_roles_on_patron_id_and_role_id", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  add_foreign_key "email_auths", "patrons"
  add_foreign_key "patrons_roles", "patrons"
  add_foreign_key "patrons_roles", "roles"
end
