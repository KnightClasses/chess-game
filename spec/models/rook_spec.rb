require 'rails_helper'

RSpec.describe Rook, type: :model do
  describe "check method on rook should return" do
    it "should tell us 'this is the rook'" do
      FactoryGirl.create(:piece,type:Rook)
      piece = Piece.last
      expected = "This is the rook"

      expect(piece.check).to eq(expected)
    end
  end
end
