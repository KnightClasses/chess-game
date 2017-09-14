require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "available scope on Game" do
    it "should return all games where black player is nill" do
      FactoryGirl.create(:game, black_player_id: nil)
      game = Game.available

      expect(game.length).to eq(1)
    end
  end
  describe "game#populate_game!" do
    it "should create 32 pieces when a game gets created" do
      FactoryGirl.create(:game)

      expect(Piece.count).to eq(32)
    end
    it "should create 6 unique pieces when a game gets created" do
      FactoryGirl.create(:game)

      expect((Piece.group(:type).count).length).to eq(6)
    end

    it "should create 16 pieces on both the black side and white side" do
      FactoryGirl.create(:game)

      expect((Piece.group(:color).count)["white"]).to eq(16)
      expect((Piece.group(:color).count)["black"]).to eq(16)
    end
  end
end
