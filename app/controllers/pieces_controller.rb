class PiecesController < ApplicationController
  def show
    @piece = Piece.find(params[:id])
  end

  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game

    @piece.update_attributes(piece_params)
  end

  private
  def piece_params
    params.require(:piece).permit(:color, :type, :x, :y)
  end
end
