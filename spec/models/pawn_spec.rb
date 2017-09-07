require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe "check method on pawn should return" do
    it "should tell us 'this is the pawn'" do
      FactoryGirl.create(:piece, type: Pawn)
      piece = Piece.last
      expected = "This is the pawn"

      expect(piece.check).to eq(expected)
    end
  end
end
