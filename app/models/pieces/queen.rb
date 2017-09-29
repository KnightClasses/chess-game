class Queen < Piece
  #method for this to use
  def check
    return "This is the queen"
  end

  def is_valid?(req_x, req_y)
    if  ((req_x - self.x).abs == (req_y - self.y).abs) || (req_x == self.x || req_y == self.y)
        return true
    else
        return false
    end
  end
end
