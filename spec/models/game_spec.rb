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

  describe "game#clear_current_board" do
    it "should remove all pieces from the current game" do
      game = FactoryGirl.create(:game)
      game.clear_current_board

      expect(Piece.where("game_id = ?",game.id).count).to eq(0)
    end
  end

  describe "game#all_from_current_game" do
    it "should return an array of all pieces in the game that match the inputs" do
      game = FactoryGirl.create(:game)
      pawns = game.find_in_game(type:"Pawn")

      expect(pawns.length).to eq(16)
    end
    it "should return an array of all the pieces for the game if no parameters given" do
      game = FactoryGirl.create(:game)

      expect(game.find_in_game.length).to eq(32)
    end
  end

  describe "game#one_from_current_game" do
    it "should return a single piece from the current game that matches the inputs" do
      game = FactoryGirl.create(:game)
      white_king = game.find_one_in_game(type:"king",color:"white")

      expect(white_king).to eq(Piece.where("game_id = ? AND type = 'King' AND color = 0",game.id).take)
    end

    it "should return a single piece from the current game that matches the inputs" do
      game = FactoryGirl.create(:game)
      white_rook = game.find_one_in_game(type:"rook",color:"white",x:1,y:1)

      expect(white_rook).to eq(Piece.where("game_id = ? AND type = 'Rook' AND color = 0 AND x = 1 AND y = 1",game.id).take)
    end
  end

  describe "game#initial_player_turn" do
    it "should initialize the player turn"do
      game = FactoryGirl.create(:game)

      expect(game.user.id).to eq(game.player_turn)
    end
  end
  describe "game#change_player_turn" do
    it "should change the active player" do
      game = FactoryGirl.create(:game)
      user = FactoryGirl.create(:user)
      game.update_attributes(black_player_id: user.id)
      game.change_player_turn

      expect(game.player_turn).to eq(user.id)
    end
  end
end
