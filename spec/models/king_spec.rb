require 'rails_helper'

RSpec.describe King, type: :model do
  describe "check method on king should return" do
    it "should tell us 'this is the king'" do
      FactoryGirl.create(:piece)
      piece = Piece.last
      expected = "This is the king"

      expect(piece.check).to eq(expected)
    end
  end

  describe "King#is_valid? method" do 
    it "should successfully detect if a move is valid" do 
      FactoryGirl.create(:piece) # piece type is king by default
      king1 = Piece.last

      expect(king1.is_valid?(2, 1)).to eq(true)
      expect(king1.is_valid?(1, 2)).to eq(true)
    end

    it "should successfully detect if a move is not valid" do 
      FactoryGirl.create(:piece) # piece type is king by default
      king1 = Piece.last

      expect(king1.is_valid?(3, 1)).to eq(false)
      expect(king1.is_valid?(1, 3)).to eq(false)
      expect(king1.is_valid?(2, 3)).to eq(false)
    end
  end
end
