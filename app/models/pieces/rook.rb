class Rook < Piece
  #method for this to use
  def check
    return "This is the rook"
  end

  def is_valid?(req_x, req_y)
    return true if req_x == self.x || req_y == self.y

    return false
  end

  def can_castle?
    #returns true if unmoved
    return true if self.updated_at == self.created_at 
  end
end
