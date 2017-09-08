class RemoveBlackPlayerFromGames < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :black_player, :integer
  end
end
