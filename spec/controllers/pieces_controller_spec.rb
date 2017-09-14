require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe "pieces#show action" do 
    it "should successfully show the page" do 
      get :show
      expect(response).to have_http_status(:success)
    end
  end


  describe "pieces#update action" do 
    it "should allow a user to successfully move (update x/y) a piece" do 
      user = FactoryGirl.create(:user)
      sign_in user
      game = FactoryGirl.create(:game)
      req_x = 4
      req_y = 4
      patch :update, params: { game_id: game.id, piece: { type: Bishop, x: req_x, y: req_y } }
      game.reload
      expect(piece.x).to eq(req_x)
      expect(piece.y).to eq(req_y)
    end
  end
end
