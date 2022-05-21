# frozen_string_literal: true

# DB migration to create teams table
class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name

      t.timestamps
    end
  end
end
