class Rook < Piece
  belongs_to :piece 
  #method for this to use
  def check
    return "This is the rook"
  end

  @rook = Piece.create do |white_rook|
    white_rook.id =  1, 
    white_rook.color = 0,
    white_rook.role = 2, 
    white_rook.x = 1,
  end

end
