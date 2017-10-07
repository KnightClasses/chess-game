class Bishop < Piece
  #method for this to use
  def check
    return "This is the bishop"
  end

  def is_valid?(req_x, req_y)
    return true if (self.x - req_x).abs == (self.y - req_y).abs

    return false
  end

  def capture_path

  end
end
