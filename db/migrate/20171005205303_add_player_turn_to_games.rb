class AddPlayerTurnToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :player_turn, :integer
  end
end
