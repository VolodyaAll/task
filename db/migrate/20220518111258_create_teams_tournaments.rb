class CreateTeamsTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :teams_tournaments do |t|
      t.belongs_to :tournament
      t.belongs_to :team
    end
  end
end
