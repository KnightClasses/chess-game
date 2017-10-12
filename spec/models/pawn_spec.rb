require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe "Pawn#is_valid? method" do 
    it "should successfully detect if a move is valid" do 
      FactoryGirl.create(:piece, type: Pawn, y:2)
      pawn1 = Pawn.last

      expect(pawn1.is_valid?(3, 3)).to eq(true)
      expect(pawn1.is_valid?(3, 4)).to eq(true)
    end

    it "should successfully detect if a move is not valid" do 
      FactoryGirl.create(:piece, type: Pawn, y:2)
      pawn1 = Pawn.last

      expect(pawn1.is_valid?(4, 2)).to eq(false)
      expect(pawn1.is_valid?(3, 5)).to eq(false)
    end

    it "should successfully detect if a move is valid for diagonal captures" do 
      game = FactoryGirl.create(:game)
      FactoryGirl.create(:piece, type: Pawn, color: "white", x:3, y:2, game_id: game.id)
      FactoryGirl.create(:piece, type: Pawn, color: "black", x:4, y:3, game_id: game.id)
      FactoryGirl.create(:piece, type: Pawn, color: "black", x:2, y:3, game_id: game.id)
      pawn1 = Piece.find_by("x = 3 AND y = 2 AND game_id = ? AND type = 'Pawn'", game.id)
      pawn2 = Piece.find_by("x = 4 AND y = 3 AND game_id = ? AND type = 'Pawn'", game.id)
      pawn3 = Piece.find_by("x = 2 AND y = 3 AND game_id = ? AND type = 'Pawn'", game.id)

      expect(pawn1.is_valid?(4, 3)).to eq(true)
      expect(pawn1.is_valid?(2, 3)).to eq(true)
    end

    it "should successfully detect if a move is not valid for straight captures" do 
      game = FactoryGirl.create(:game)
      FactoryGirl.create(:piece, type: Pawn, color: "white", x:3, y:2, game_id: game.id)
      FactoryGirl.create(:piece, type: Pawn, color: "black", x:3, y:3, game_id: game.id)
      pawn1 = Piece.find_by("x = 3 AND y = 2 AND game_id = ? AND type = 'Pawn'", game.id)
      pawn2 = Piece.find_by("x = 3 AND y = 3 AND game_id = ? AND type = 'Pawn'", game.id)

      expect(pawn1.is_valid?(3, 3)).to eq(false)
    end
  end
end
