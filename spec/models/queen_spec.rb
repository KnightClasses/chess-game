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
end
