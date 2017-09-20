class PiecesController < ApplicationController

  def show
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game


    row = piece_params[:x]
    column = piece_params[:y]

    @piece.move_to!(row, column, @game.id)

    redirect_to game_path(@game)

  end


  private


  def piece_params
    params.require(:piece).permit(:x, :y)
  end
end
