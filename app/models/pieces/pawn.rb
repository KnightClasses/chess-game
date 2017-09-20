class Pawn < Piece
  #method for this to use
  def check
    return "This is the pawn"
  end

  def is_valid?(req_x, req_y)
    if self.color == "white"
      if self.y == 2
        return true if (req_x == self.x && req_y == self.y + 2) || (req_x == self.x && req_y == self.y + 1)
      else
        return true if (req_x == self.x && req_y == self.y + 1)
      end
    end
    
    if self.color == "black"
      if self.y == 7
        return true if req_x == self.x && req_y == self.y - 2 || (req_x == self.x && req_y == self.y - 1)
      else
        return true if (req_x == self.x && req_y == self.y - 1)
      end
    end
  return false
  end
end
