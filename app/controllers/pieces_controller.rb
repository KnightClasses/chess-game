class PiecesController < ApplicationController
  def show
    @piece = Piece.find(params[:id])
  end

  def update

  end
end
