class PiecesController < ApplicationController
  def show
    @piece = Piece.find(params[:id])
    @game =@piece.game
  end

  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game

    @piece.update(piece_params)
    redirect_to game_path(@game)
  end

  private
  def piece_params
    params.require(:piece).permit(:x, :y)
  end
end
