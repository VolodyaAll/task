class CreateDivisions < ActiveRecord::Migration[5.0]
  def change
    create_table :divisions do |t|
      t.string :name
      t.integer :tournament_id

      t.timestamps
    end
  end
end
