class King < Piece
  #method for this to use
  def check
    return "This is the king"
  end

  def is_valid?(req_x, req_y)
    return true if (req_x - self.x).abs <= 1 && (req_y - self.y).abs <= 1

    return false
  end
end
