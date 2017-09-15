class Pawn < Piece
  belongs_to :piece
  #method for this to use
  def check
    return "This is the pawn"
  end


end
