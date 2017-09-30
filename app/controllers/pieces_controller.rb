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
    @piece.move_to!(req_x, req_y, @game.id)
    render json: @piece
  end

  private

  def validate_move
    @piece = Piece.find(params[:id])
    @game = @piece.game
    req_x = piece_params[:x].to_i
    req_y = piece_params[:y].to_i

    if @piece.same_team?(req_x, req_y, @game.id)
      respond_to do |format|
        format.js { flash[:notice] = "You cannot capture your own piece. Please try again." }
      end
    end

    @piece.move_to!(req_x, req_y, @game.id) if @piece.is_valid?(req_x, req_y) && !@piece.is_obstructed?(req_x, req_y, @game.id) 

    render json: @piece
  end

  def piece_params
    params.require(:piece).permit(:x, :y)
  end
end
