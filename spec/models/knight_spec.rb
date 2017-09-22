require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe "check method on knight should return" do
    it "should tell us 'this is the knight'" do
      FactoryGirl.create(:piece, type: Knight)
      piece = Piece.last
      expected = "This is the knight"

      expect(piece.check).to eq(expected)
    end
    
    it "should detect is a move is valid" do
      FactoryGirl.create(:piece, type:Knight,x:5,y:5)
      knight = Knight.last
      expected = true

      expect(knight.is_valid?(7,6)).to eq(expected)
    end

    it "should detect is a move is valid" do
      FactoryGirl.create(:piece, type:Knight,x:5,y:5)
      knight = Knight.last
      expected = true

      expect(knight.is_valid?(4,3)).to eq(expected)
    end

    it "should detect is a move is valid" do
      FactoryGirl.create(:piece, type:Knight,x:5,y:5)
      knight = Knight.last
      expected = true

      expect(knight.is_valid?(3,6)).to eq(expected)
    end

    it "should detect if a move is illegal" do
      FactoryGirl.create(:piece, type:Knight,x:5,y:5)
      knight = Knight.last
      expected = false

      expect(knight.is_valid?(9,1000)).to eq(expected)
    end

    it "should detect if a move is illegal" do
      FactoryGirl.create(:piece, type:Knight,x:5,y:5)
      knight = Knight.last
      expected = false

      expect(knight.is_valid?(1,1)).to eq(expected)
    end
  end
end
