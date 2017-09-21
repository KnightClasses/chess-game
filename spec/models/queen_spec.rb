require 'rails_helper'

RSpec.describe Queen, type: :model do
  describe "check method on queen should return" do
    it "should tell us 'this is the queen'" do
      FactoryGirl.create(:piece, type: Queen)
      queen1 = Queen.last
      expected = "This is the queen"

      expect(queen1.check).to eq(expected)
    end
  end

  describe "Queen#is_valid" do
    it "should tell if the queens move is valid" do
      FactoryGirl.create(:piece, type: Queen)
      queen1 = Queen.last
      expect(queen1.is_valid?(3,4)).to eq(true)
      expect(queen1.is_valid?(8,3)).to eq(true)
      expect(queen1.is_valid?(1,5)).to eq(true)
    end

    it "should tell us the queen's move is invalid" do
      FactoryGirl.create(:piece, type: Queen)
      queen1 = Queen.last
      expect(queen1.is_valid?(5,2)).to eq(false)
      expect(queen1.is_valid?(8,1)).to eq(false)
    end
  end
end
