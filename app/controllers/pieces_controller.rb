class PiecesController < ApplicationController

  def show
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game
    req_x = piece_params[:x].to_i
    req_y = piece_params[:y].to_i

    if @piece.valid_move?(req_x, req_y) && @game.player_turn_color == @piece.color
      @piece.move_to!(req_x, req_y)
      @game.change_player_turn
    end
    render json: @piece
  end

  private

  def piece_params
    params.require(:piece).permit(:x, :y)
  end
end
