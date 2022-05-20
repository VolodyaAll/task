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

ActiveRecord::Schema.define(version: 20220520085324) do

  create_table "divisions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string   "name"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "divisions_teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.integer "division_id"
    t.integer "team_id"
    t.index ["division_id"], name: "index_divisions_teams_on_division_id", using: :btree
    t.index ["team_id"], name: "index_divisions_teams_on_team_id", using: :btree
  end

  create_table "games", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.integer  "division_id"
    t.integer  "team_one_id"
    t.integer  "team_two_id"
    t.integer  "winner_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "playoffs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string   "name"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams_tournaments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.integer "tournament_id"
    t.integer "team_id"
    t.index ["team_id"], name: "index_teams_tournaments_on_team_id", using: :btree
    t.index ["tournament_id"], name: "index_teams_tournaments_on_tournament_id", using: :btree
  end

  create_table "tournaments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string   "name",                         null: false
    t.string   "status",     default: "draft", null: false
    t.integer  "winner_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

end
