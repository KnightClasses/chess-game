require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe "pieces#update action" do 
    it "should allow a user to successfully move (update x/y) a piece" do 
      user = FactoryGirl.create(:user)
      sign_in user
      game = FactoryGirl.create(:game)
      piece = Piece.find_by(x: 1, y: 2)
      req_x = piece.x
      req_y = piece.y + 1
      patch :update, params: { game_id: game.id, id: piece.id, piece: { x: req_x, y: req_y } }
      game.reload
      piece.reload
      expect(piece.x).to eq(req_x)
      expect(piece.y).to eq(req_y)
    end
  end
end
