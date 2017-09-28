class PiecesController < ApplicationController
  before_action :validate_move, only: [:update]

  def show
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game
    req_x = piece_params[:x].to_i
    req_y = piece_params[:y].to_i
    @piece.move_to!(req_x, req_y, @game.id) if class_eval(@piece.type).find_by_game_id(@game.id).is_valid?(req_x,req_y)
    render json: @piece
  end

  private
  
  def validate_move
    @piece = Piece.find(params[:id])
    @game = @piece.game
    req_x = piece_params[:x]
    req_y = piece_params[:y]

    if @piece.same_team?(req_x, req_y, @game.id)
      respond_to do |format|
        format.js { flash[:notice] = "You cannot capture your own piece. Please try again." }
      end
    end
  end

  def piece_params
    params.require(:piece).permit(:x, :y)
  end
end
