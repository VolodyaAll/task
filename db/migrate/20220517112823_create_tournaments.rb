class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.string :name, null: false
      t.string :status, null: false, default: 'draft'
      t.integer :winner_id, null: true

      t.timestamps
    end
  end
end
