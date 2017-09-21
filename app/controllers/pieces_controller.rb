class PiecesController < ApplicationController
  before_action :only => :update do
    validate_move(piece_params)
  end

  def show
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game
    req_x = piece_params[:x]
    req_y = piece_params[:y]
    @piece.move_to!(req_x, req_y, @game.id)
    redirect_to game_path(@game)
  end


  private

  def validate_move(piece_params)
    @piece = Piece.find(params[:id])
    req_color = piece_params[:color]

    # if @piece.color == req_color
      # flash[:notice] = "You can not capture your own piece. Please try again."
    # end

  end

  def piece_params
    params.require(:piece).permit(:x, :y, :color)
  end
end
