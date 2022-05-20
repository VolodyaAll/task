class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :division_id
      t.integer :team_one_id
      t.integer :team_two_id
      t.integer :winner_id

      t.timestamps
    end
  end
end
