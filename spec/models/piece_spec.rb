require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe "Piece#is_obstructed? method" do
    it "should successfully detect if a move is obstructed (horizontal)" do
      rook1 = FactoryGirl.create(:piece, type:Rook) #x:3,y:3
      rook2 = FactoryGirl.create(:piece, type:Rook,x:5) #x:5,y:3

      expect(rook1.is_obstructed?(6,3)).to eq(true)
    end

    it "should successfully detect if a move is not obstructed (horizontal)" do
      pawn1 = FactoryGirl.create(:piece, type:Pawn) #x:3,y:3

      expect(pawn1.is_obstructed?(2,3)).to eq(false)
    end

    it "should successfully detect if a move is obstructed (vertical)" do
      rook1 = FactoryGirl.create(:piece, type:Rook) #x:3,y:3
      rook2 = FactoryGirl.create(:piece, type:Rook,y:5) #x:3,y:5

      expect(rook1.is_obstructed?(3,6)).to eq(true)
    end

    it "should successfully detect if a move is not obstructed (vertical)" do
      pawn1 = FactoryGirl.create(:piece, type:Pawn) #x:3,y:3

      expect(pawn1.is_obstructed?(3,4)).to eq(false)
    end

    it "should successfully detect if a move is obstructed (diagonal)" do
      bishop1 = FactoryGirl.create(:piece, type:Bishop) #x:3,y:3
      bishop2 = FactoryGirl.create(:piece, type:Bishop,x:4,y:4) #x:4,y:4

      expect(bishop1.is_obstructed?(5,5)).to eq(true)
    end

    it "should successfully detect if a move is not obstructed (diagonal)" do
      bishop1 = FactoryGirl.create(:piece, type:Bishop) #x:3,y:3

      expect(bishop1.is_obstructed?(5,5)).to eq(false)
    end

    it "should successfully detect if a move is illegal (neither horizontal, vertical, nor diagonal)" do
      pawn1 = FactoryGirl.create(:piece, type:Pawn) #x:3,y:3

      expect(pawn1.is_obstructed?(2,5)).to eq("invalid move")
    end
  end
end
