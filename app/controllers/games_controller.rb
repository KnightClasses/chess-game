class GamesController < ApplicationController
  before_action :active_game?, only: [:show, :update]

  def index
  end

  def new
    @game = Game.new
  end

  def create
    @game = current_user.games.create(game_params)
    @game.white_player_id = current_user.id
    @game.save
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find(params[:id])
    @black_king = @game.pieces.find_by("type = 'King' AND color = 1")
    @white_king = @game.pieces.find_by("type = 'King' AND color = 0")
    @pieces_captured_by_black = @game.pieces.where(color: "white", active: false)
    @pieces_captured_by_white = @game.pieces.where(color: "black", active: false)
  end

  def update
    @game = Game.find(params[:id])
    return render_status(:forbidden) if @game.black_player_id

    @game.update_attribute(:black_player_id, current_user.id)
    @game.save
    redirect_to game_path(@game)
  end

  def active
    @game = Game.find(params[:id])
    @game.update_attribute(:active, false)
    redirect_to root_path
  end


  private

  def active_game?
    @game = Game.find(params[:id])
    @active_state = @game.active
    if @active_state == false
      redirect_to root_path
    end
  end

  def game_params
    params.require(:game).permit(:name,:white_player_id, :black_player_id)
  end
end
