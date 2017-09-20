require 'rails_helper'

RSpec.describe Queen, type: :model do
  describe "check method on queen should return" do
    it "should tell us 'this is the queen'" do
      FactoryGirl.create(:piece, type: Queen)
      piece = Piece.last
      expected = "This is the queen"

      expect(piece.check).to eq(expected)
    end
  end


  describe "Queen#is_valid" do
    it "should tell if the queens move is valid" do
      FactoryGirl.create(:piece, type: Queen)
      piece = Piece.last
      expect(piece.is_valid(3,4)).to eq(true)
      expect(piece.is_valid(8,3)).to eq(true)
    end

    it "should tell us the queen's move is invalid" do
      FactoryGirl.create(:piece, type: Queen)
      piece = Piece.last
      expect(piece.is_valid(5,2)).to eq(false)
      expect(piece.is_valid(8,1)).to eq(false)
    end
  end
end
