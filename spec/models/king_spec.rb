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
      game = FactoryGirl.create(:game)
      FactoryGirl.create(:piece, type: Rook, x: 8, y:4, game_id: game.id)
      FactoryGirl.create(:piece, x:5 ,y:4, game_id: game.id)
      king = Piece.where("x = 5 AND y = 4 AND game_id = ?", game.id).take
      
      expect(king.can_castle?(7, king.y)).to eq(true)
    end

    it "should not let me castle if I have moved" do
      game = FactoryGirl.create(:game)
      FactoryGirl.create(:piece, type: Rook, x: 8, y:4, game_id: game.id)
      FactoryGirl.create(:piece, x:5 ,y:4, game_id: game.id)
      king = Piece.where("x = 5 AND y = 4 AND game_id = ?", game.id).take
      
      expect(king.can_castle?(1, king.y)).to eq(false)
    end
  end

  describe "King#castle!" do
    it "should let me castle if king and rook are unmoved" do
      game = FactoryGirl.create(:game)
      game.clear_current_board
      FactoryGirl.create(:piece, type: Rook, x: 8, y:1, game_id: game.id,active:true)
      FactoryGirl.create(:piece, x:5 ,y:1, game_id: game.id,active:true)
      rook = Piece.where("x = 8 AND y = 1 AND game_id = ? AND type = 'Rook'", game.id).take
      king = Piece.where("x = 5 AND y = 1 AND game_id = ?", game.id).take
      king.castle!(7, king.y)
      king.reload
      rook.reload

      expect(king.x).to eq(7)
      expect(rook.x).to eq(6)
    end

    it "should NOT let me castle if king if moved" do
      game = FactoryGirl.create(:game)
      FactoryGirl.create(:piece, type: Rook, x: 8, y:4, game_id: game.id)
      FactoryGirl.create(:piece, x:5 ,y:4, game_id: game.id)
      king = Piece.where("x = 5 AND y = 4 AND game_id = ? AND type = 'King'", game.id).take
      king.update_attributes(x:6)
      king.castle!(7, king.y)
      king.reload

      expect(king.x).to eq(6)
    end

    it "should NOT let me castlie if rook is moved" do
      game = FactoryGirl.create(:game)
      FactoryGirl.create(:piece, type: Rook, x: 8, y:4, game_id: game.id)
      FactoryGirl.create(:piece, x:5 ,y:4, game_id: game.id)
      rook = Piece.where("x = 8 AND y = 4 AND game_id = ? AND type = 'Rook'", game.id).take
      king = Piece.where("x = 5 AND y = 4 AND game_id = ? AND type = 'King'", game.id).take
      rook.update_attributes(x:6)
      king.castle!(7, king.y)
      king.reload

      expect(king.x).to eq(5)
    end
    it "should NOT let me castle if I am in check" do
      game = FactoryGirl.create(:game)
      game.clear_current_board
      FactoryGirl.create(:piece,type:King,x:5,y:1,game_id: game.id)
      white_rook = FactoryGirl.create(:piece,type: Rook,x:8,y:1,game_id: game.id)
      black_rook = FactoryGirl.create(:piece,color:1,type:Rook,x:5,y:8,game_id: game.id)
      king = Piece.where("x = 5 AND y = 1 AND game_id = ? AND type = 'King'", game.id).take
      king.castle!(7,king.y)
      king.reload

      expect(king.x).to eq(5)
      expect(king.y).to eq(1)
    end
  end
  describe "king#check?" do
    it "should successfully detect if a movement will end up in check" do
      game = FactoryGirl.create(:game)
      game.clear_current_board
      FactoryGirl.create(:piece,x:4,y:1,active:true,game_id:game.id)
      FactoryGirl.create(:piece,type:Rook,active:true,color:1,x:5,y:8,game_id:game.id)
      king = game.find_one_in_game(x:4,y:1)
      
      expect(king.check?(5,1)).to eq(true)
    end
    it "should successfully detect if I am currently in check" do
      game = FactoryGirl.create(:game)
      game.clear_current_board
      FactoryGirl.create(:piece,x:5,y:1,game_id:game.id)
      FactoryGirl.create(:piece,type:Rook,color:1,x:5,y:8,game_id:game.id)
      king = game.find_one_in_game(x:5,y:1)
      
      expect(king.check?).to eq(true)
    end
    it "should successfully detect if I am NOT in check" do
      game = FactoryGirl.create(:game)
      game.clear_current_board
      FactoryGirl.create(:piece,x:4,y:1,game_id:game.id)
      FactoryGirl.create(:piece,type:Rook,color:1,x:5,y:8,game_id:game.id)
      king = game.find_one_in_game(x:4,y:1)
      
      expect(king.check?).to eq(false)
    end
    it "should return FALSE if the movement will NOT land me in check" do
      game = FactoryGirl.create(:game)
      game.clear_current_board
      FactoryGirl.create(:piece,x:6,y:1,active:true,game_id:game.id)
      FactoryGirl.create(:piece,active:true,type:Rook,color:1,x:5,y:8,game_id:game.id)
      king = game.find_one_in_game(x:6,y:1)
      
      expect(king.check?(7,1)).to eq(false)
    end
  end
  describe "king#checkmate?" do
    it "should successfully detect if a King's position is checkmated" do
      game = FactoryGirl.create(:game)
      game.clear_current_board
      FactoryGirl.create(:piece,type: King,active:true,color:1,x:7,y:1,game_id:game.id)
      FactoryGirl.create(:piece,type:Queen,active:true,color:0,x:3,y:1,game_id:game.id)
      FactoryGirl.create(:piece,type:King,active:true,color:0,x:7,y:3,game_id:game.id)
      FactoryGirl.create(:piece,type:Rook,active:true,color:0,x:1,y:8,game_id:game.id)
      king = game.pieces.find_by(x:7,y:1)

      expect(king.game.checkmate?(1)).to eq(true)
    end
    it "should successfully detect if a King's position is NOT checkmated" do
      game = FactoryGirl.create(:game)
      game.clear_current_board
      FactoryGirl.create(:piece,type: King,active:true,color:1,x:7,y:1,game_id:game.id)
      FactoryGirl.create(:piece,type:Queen,active:true,color:0,x:3,y:3,game_id:game.id)
      FactoryGirl.create(:piece,type:King,active:true,color:0,x:7,y:3,game_id:game.id)
      FactoryGirl.create(:piece,type:Rook,active:true,color:0,x:1,y:8,game_id:game.id)
      king = game.pieces.find_by(x:7,y:1)

      expect(king.game.checkmate?(1)).to eq(false)
    end
    it "should successfully detect if a King's position is checkmated" do
      game = FactoryGirl.create(:game)
      game.clear_current_board
      FactoryGirl.create(:piece,type: Rook,active:true,color:0,x:1,y:8,game_id:game.id)
      FactoryGirl.create(:piece,type: King,active:true,color:0,x:7,y:1,game_id:game.id)
      FactoryGirl.create(:piece,type: King,active:true,color:1,x:7,y:8,game_id:game.id)
      FactoryGirl.create(:piece,type:Pawn,active:true,color:1,x:6,y:7,game_id:game.id)
      FactoryGirl.create(:piece,type:Pawn,active:true,color:1,x:7,y:7,game_id:game.id)
      FactoryGirl.create(:piece,type:Pawn,active:true,color:1,x:8,y:7,game_id:game.id)
      king = game.pieces.find_by(x:7,y:8)

      expect(king.game.checkmate?(1)).to eq(true)
    end
  end

end
