require 'rails_helper'

RSpec.describe Bishop, type: :model do
  describe "check method on bishop should return" do
    it "should tell us 'this is the bishop'" do
      FactoryGirl.create(:piece, type: Bishop)
      bishop1 = Bishop.last
      expected = "This is the bishop"

      expect(bishop1.check).to eq(expected)
    end
  end

  describe "Bishop#is_valid?" do
    it "should tell us if the bishop Piece is moving to a valid spot" do
      FactoryGirl.create(:piece, type: Bishop)
      bishop1 = Bishop.last

      expect(bishop1.is_valid?(5, 5)).to eq(true)
      expect(bishop1.is_valid?(1, 5)).to eq(true)
      expect(bishop1.is_valid?(1, 1)).to eq(true)
    end

    it "should tell us that the move is invalid" do
<<<<<<< HEAD
      FactoryGirl.create(:piece, type: Bishop)
      bishop1 = Bishop.last
      
      
      expect(bishop1.is_valid?(3,5)).to eq(false)
      expect(bishop1.is_valid?(5,3)).to eq(false)
=======
      FactoryGirl.create(:piece, type: Bishop, x:1, y:1)
      piece = Piece.last
      expect(piece.is_valid(7,8)).to eq(false)
      expect(piece.is_valid(6,4)).to eq(false)
>>>>>>> 3bc68afda86b60ed3d1b5722f23318d7ac9c93db
    end
end

end

