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
end
