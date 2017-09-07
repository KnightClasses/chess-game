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
end
