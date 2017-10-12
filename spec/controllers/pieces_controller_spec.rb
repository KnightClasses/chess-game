require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe "pieces#update action" do
    it "should allow a user to successfully move (update x/y) a piece" do
      user = FactoryGirl.create(:user)
      sign_in user
      game = FactoryGirl.create(:game)
      #piece = Piece.find_by(x: 1, y: 2)
      piece = game.find_one_in_game(x:1,y:2,type:"Pawn")
      req_x = piece.x
      req_y = piece.y + 1
      patch :update, params: { game_id: game.id, id: piece.id, piece: { x: req_x, y: req_y } }
      game.reload
      piece.reload
      expect(piece.x).to eq(req_x)
      expect(piece.y).to eq(req_y)
    end
    it "should reject a king movement if it would force it into check" do
      user = FactoryGirl.create(:user)
      sign_in user
      game = FactoryGirl.create(:game)
      game.clear_current_board
      FactoryGirl.create(:piece,x:4,y:1,active:true,game_id:game.id)
      FactoryGirl.create(:piece,type:Rook,active:true,color:1,x:5,y:8,game_id:game.id)
      king = game.find_one_in_game(x:4,y:1)
      patch :update, params: { game_id: game.id, id:king.id, piece: {x:5,y:1 } }
      king.reload

      expect(king.x).to eq(4)
      expect(king.y).to eq(1)
    end
    it "should do nothing if the moving piece is not the player_turn's piece" do
      game = FactoryGirl.create(:game)
      pawn = game.find_one_in_game(type:"Knight",color:"Black",x:2,y:8)
      patch :update, params: { game_id: game.id, id: pawn.id, piece: {x:1,y:6} }
      pawn.reload

      expect(pawn.x).to eq(2)
      expect(pawn.y).to eq(8)
    end
  end
  describe "pieces#promote_pawn" do
    it "should allow us to promote the pawn if promotable" do
      game = FactoryGirl.create(:game)
      game.clear_current_board
      FactoryGirl.create(:piece,type:Pawn,x:8,y:7,game_id:game.id)
      FactoryGirl.create(:piece,type:Queen,x:1,y:1,game_id:game.id)
      FactoryGirl.create(:piece,type:King,x:6,y:1,game_id:game.id)
      pawn = game.find_one_in_game(type:"Pawn",color:"White",x:8,y:7)
      patch :update, params: { game_id: game.id, id: pawn.id, piece: {x:8,y:8} }
      patch :promote_pawn, params: { game_id: game.id, id: pawn.id, piece: {type:"Queen" } }
      queens = game.find_in_game(type:"Queen",color:"White")

      expect(queens.count).to eq(2)
    end
  end
end
