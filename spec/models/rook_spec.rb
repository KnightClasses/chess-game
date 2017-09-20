require 'rails_helper'

RSpec.describe Rook, type: :model do
  describe "check method on rook should return" do
    it "should tell us 'this is the rook'" do
      FactoryGirl.create(:piece,type: Rook)
      piece = Piece.last
      expected = "This is the rook"

      expect(piece.check).to eq(expected)
    end
  end

  describe "Rook#is_valid? method" do 
    it "should successfully detect if a move is valid" do 
      FactoryGirl.create(:piece, type: Rook)
      rook1 = Rook.last

      expect(rook1.is_valid?(6, 3)).to eq(true)
      expect(rook1.is_valid?(3, 6)).to eq(true)
    end

    it "should successfully detect if a move is not valid" do 
      FactoryGirl.create(:piece, type: Rook)
      rook1 = Rook.last

      expect(rook1.is_valid?(4, 5)).to eq(false)
      expect(rook1.is_valid?(2, 2)).to eq(false)
    end
  end
end
