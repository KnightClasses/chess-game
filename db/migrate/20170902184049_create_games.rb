class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :white_player
      t.integer :black_player
      t.timestamps
    end

    add_index :games, [:white_player, :black_player]
    add_index :games, :black_player
  end
end
