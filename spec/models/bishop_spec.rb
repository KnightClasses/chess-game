require 'rails_helper'

RSpec.describe Bishop, type: :model do
  describe "Bishop#is_valid?" do
    it "should tell us if the bishop Piece is moving to a valid spot" do
      FactoryGirl.create(:piece, type: Bishop)
      bishop1 = Bishop.last

      expect(bishop1.is_valid?(5, 5)).to eq(true)
      expect(bishop1.is_valid?(1, 5)).to eq(true)
      expect(bishop1.is_valid?(1, 1)).to eq(true)
    end

    it "should tell us that the move is invalid" do
      FactoryGirl.create(:piece, type: Bishop)
      bishop1 = Bishop.last
      
      
      expect(bishop1.is_valid?(3,5)).to eq(false)
      expect(bishop1.is_valid?(5,3)).to eq(false)
    end
  end
end

