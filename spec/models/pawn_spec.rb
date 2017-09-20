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
  end
end
