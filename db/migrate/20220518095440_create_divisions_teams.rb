class CreateDivisionsTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :divisions_teams do |t|
      t.belongs_to :division
      t.belongs_to :team
    end
  end
end
