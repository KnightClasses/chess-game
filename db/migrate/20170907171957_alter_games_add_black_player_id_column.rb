class AlterGamesAddBlackPlayerIdColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :black_player_id, :integer
    add_index :games, :black_player_id
  end
end
