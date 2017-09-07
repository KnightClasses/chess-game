require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe "check method on knight should return" do
    it "should tell us 'this is the knight'" do
      FactoryGirl.create(:piece, type: Knight)
      piece = Piece.last
      expected = "This is the knight"

      expect(piece.check).to eq(expected)
    end
  end
end
