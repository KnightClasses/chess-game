class PiecesController < ApplicationController
  def show
    @game = Game.find(params[:game_id])
    @piece = @game.pieces.find(params[:id])
  end

  def update
    @game = Game.find(params[:game_id])
    @piece = @game.pieces.find(params[:id])

    @piece.update_attributes(piece_params)
  end

  private
  def piece_params
    params.require(:piece).permit(:color, :type, :x, :y)
  end
end
