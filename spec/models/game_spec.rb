require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "available scope on Game" do
    it "should return all games where black player is nill" do
      FactoryGirl.create(:game, black_player_id: nil)
      game = Game.available

      expect(game.length).to eq(1)
    end
  end
end
