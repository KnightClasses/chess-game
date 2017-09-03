class CreatePieces < ActiveRecord::Migration[5.0]
  def change
    create_table :pieces do |t|
      t.integer :color
      t.string :type
      t.string :x 
      t.string :y 
      t.integer :game_id
      t.timestamps
    end

    add_index :pieces, :game_id
  end
end
