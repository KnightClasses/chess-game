require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe "Piece#is_obstructed? method" do
    it "should successfully detect if a move is obstructed (horizontal)" do
      pawn1 = FactoryGirl.create(:piece, type:Pawn) #x:1,y:1
      pawn2 = FactoryGirl.create(:piece, type:Pawn,x:5) #x:5,y:1

      expect(pawn1.is_obstructed?(10,1)).to eq(true)
    end

    it "should successfully detect if a move is not obstructed (horizontal)" do
      pawn1 = FactoryGirl.create(:piece, type:Pawn) #x:1,y:1

      expect(pawn1.is_obstructed?(10,1)).to eq(false)
    end

    it "should successfully detect if a move is obstructed (vertical)" do
      pawn1 = FactoryGirl.create(:piece, type:Pawn) #x:1,y:1
      pawn2 = FactoryGirl.create(:piece, type:Pawn,y:5) #x:1,y:5

      expect(pawn1.is_obstructed?(1,10)).to eq(true)
    end

    it "should successfully detect if a move is not obstructed (vertical)" do
      pawn1 = FactoryGirl.create(:piece, type:Pawn) #x:1,y:1

      expect(pawn1.is_obstructed?(1,10)).to eq(false)
    end

    it "should successfully detect if a move is obstructed (diagonal)" do
      pawn1 = FactoryGirl.create(:piece, type:Pawn) #x:1,y:1
      pawn2 = FactoryGirl.create(:piece, type:Pawn,x:3,y:3) #x:3,y:3

      expect(pawn1.is_obstructed?(7,7)).to eq(true)
    end

    it "should successfully detect if a move is not obstructed (diagonal)" do
      pawn1 = FactoryGirl.create(:piece, type:Pawn) #x:1,y:1

      expect(pawn1.is_obstructed?(7,7)).to eq(false)
    end

    it "should successfully detect if a move is illegal (neither horizontal, vertical, nor diagonal)" do
      pawn1 = FactoryGirl.create(:piece, type:Pawn) #x:1,y:1

      expect(pawn1.is_obstructed?(2,3)).to eq("invalid move")
    end
  end
end
