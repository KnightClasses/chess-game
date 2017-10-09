require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe "check method on pawn should return" do
    it "should tell us 'this is the pawn'" do
      FactoryGirl.create(:piece, type: Pawn)
      piece = Piece.last
      expected = "This is the pawn"

      expect(piece.check).to eq(expected)
    end
  end

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
      pawn1 = FactoryGirl.create(:piece, type: Pawn, color: 0, x:3, y:2, game_id: game.id)
      pawn2 = FactoryGirl.create(:piece, type: Pawn, color: 1, x:4, y:3, game_id: game.id)
      pawn3 = FactoryGirl.create(:piece, type: Pawn, color: 1, x:2, y:3, game_id: game.id)

      puts ""
      puts pawn1.inspect
      puts pawn1.type

      expect(pawn1.is_valid?(4, 3)).to eq(true)
      expect(pawn1.is_valid?(2, 3)).to eq(true)
    end
  end
end
