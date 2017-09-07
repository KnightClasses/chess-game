class RemoveWhitePlayerFromGames < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :white_player, :integer
  end
end
