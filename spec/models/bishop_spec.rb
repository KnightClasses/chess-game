require 'rails_helper'

RSpec.describe Bishop, type: :model do
  describe "check method on bishop should return" do
    it "should tell us 'this is the bishop'" do
      FactoryGirl.create(:piece, type: Bishop)
      piece = Piece.last
      expected = "This is the bishop"

      expect(piece.check).to eq(expected)
    end
  end

  describe "Bishop#is_valid?" do
    it "should tell us if the bishop Piece is moving to a valid spot" do
      FactoryGirl.create(:piece, type: Bishop, x: 1, y:1)
      piece = Piece.last

      expect(piece.is_valid(1, 6)).to eq(true)
      expect(piece.is_valid(1, 2)).to eq(true)
      expect(piece.is_valid(1, 3)).to eq(true)
    end

    it "should tell us that the move is invalid" do
      FactoryGirl.create(:piece, type: Bishop, x:1, y:1)
      piece = Piece.last
      expect(piece.is_valid(7,8)).to eq(false)
      expect(piece.is_valid(6,4)).to eq(false)
    end
end

end

