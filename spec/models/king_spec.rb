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

  describe "King#is_valid? method" do 
    it "should successfully detect if a move is valid" do 
      FactoryGirl.create(:piece) # piece type is king by default
      king1 = Piece.last

      expect(king1.is_valid?(4, 3)).to eq(true)
      expect(king1.is_valid?(3, 4)).to eq(true)
    end

    it "should successfully detect if a move is not valid" do 
      FactoryGirl.create(:piece) # piece type is king by default
      king1 = Piece.last

      expect(king1.is_valid?(3, 1)).to eq(false)
      expect(king1.is_valid?(1, 3)).to eq(false)
      expect(king1.is_valid?(2, 5)).to eq(false)
    end
  end

  describe "King#can_castle?" do
    it "should let me castle if I haven't moved" do
      FactoryGirl.create(:piece)
      king = Piece.last
      
      expect(king.can_castle?).to eq(true)
    end

    it "should not let me castle if I have moved" do
      FactoryGirl.create(:piece)
      king = Piece.last
      king.update_attributes(x:8)

      expect(king.can_castle?).to eq(false)
    end
  end

  describe "King#castle!" do
    it "should let me castle if king and rook are unmoved" do
      game = FactoryGirl.create(:game)
      FactoryGirl.create(:piece, type: Rook, x: 8, y:4, game_id: game.id)
      FactoryGirl.create(:piece, x:5 ,y:4, game_id: game.id)
      king = Piece.where("x = 5 AND y = 4 AND game_id = ?", game.id).take
      king.castle!(7)
      king.reload

      expect(king.y).to eq(7)
    end

    it "should NOT let me castle if king if moved" do
      game = FactoryGirl.create(:game)
      FactoryGirl.create(:piece, type: Rook, x: 8, y:4, game_id: game.id)
      FactoryGirl.create(:piece, x:5 ,y:4, game_id: game.id)
      king = Piece.where("x = 5 AND y = 4 AND game_id = ?", game.id).take
      king.update_attributes(x:6)
      king.castle!(7)
      king.reload

      expect(king.x).to eq(6)
    end

    it "should NOT let me castlie if rook is moved" do
      "******"
      FactoryGirl.create(:piece, type: Rook, x: 8, y:8)
      FactoryGirl.create(:piece, x:5 ,y:8)
      rook = Piece.where("type = 'Rook'").take
      king = Piece.last
      rook.update_attributes(x:6)
      king.castle!(7)
      king.reload

      expect(king.x).to eq(5)
    end
    it "should NOT let me castle if I am in check" do
    end
  end
end
