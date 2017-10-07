class Rook < Piece
  #method for this to use
  def check
    return "This is the rook"
  end

  def is_valid?(req_x, req_y)
    return true if req_x == self.x || req_y == self.y

    return false
  end

  def capture_path

  end
end
