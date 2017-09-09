require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "games#new action" do
    it "should successfully show the page" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "game#create action" do
    it "should successfully create a new game in our database" do
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, params: { game: { name: 'Hello' } }
      expect(response).to redirect_to game_path("#{Game.last.id}")
      game = Game.last
      expect(game.name).to eq("Hello")
      expect(game.white_player_id).to eq(user.id)
    end
  end

  describe "game#update action" do
    it "should allow for a user to join(update black_player_id) a game" do
      game = FactoryGirl.create(:game)
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, params: { id: game.id, game: { black_player_id: user.id } }
      game.reload
      expect(game.black_player_id).to eq(user.id)
    end
  end

end
