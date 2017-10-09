class Pawn < Piece
  #method for this to use
  def check
    return "This is the pawn"
  end

  def is_valid?(req_x, req_y)
    if self.color == "white"
      if self.y == 2
        return true if (req_x == self.x && req_y == self.y + 2)
        return true if (req_x == self.x && req_y == self.y + 1)
        return true if req_x == self.x + 1 && req_y == self.y + 1 && (game.pieces.find_by(x: self.x + 1, y: self.y + 1).present?)
        return true if req_x == self.x - 1 && req_y == self.y + 1 && (game.pieces.find_by(x: self.x - 1, y: self.y + 1).present?)
      else
        return true if (req_x == self.x && req_y == self.y + 1) 
        return true if req_x == self.x + 1 && req_y == self.y + 1 && (game.pieces.find_by(x: self.x + 1, y: self.y + 1).present?)
        return true if req_x == self.x - 1 && req_y == self.y + 1 && (game.pieces.find_by(x: self.x - 1, y: self.y + 1).present?)
      end
    end
    
    if self.color == "black"
      if self.y == 7
        return true if (req_x == self.x && req_y == self.y - 2)
        return true if (req_x == self.x && req_y == self.y - 1)
        return true if req_x == self.x + 1 && req_y == self.y - 1 && (game.pieces.find_by(x: self.x + 1, y: self.y - 1).present?)
        return true if req_x == self.x - 1 && req_y == self.y - 1 && (game.pieces.find_by(x: self.x - 1, y: self.y - 1).present?)
      else
        return true if (req_x == self.x && req_y == self.y - 1)
        return true if req_x == self.x + 1 && req_y == self.y - 1 && (game.pieces.find_by(x: self.x + 1, y: self.y - 1).present?)
        return true if req_x == self.x - 1 && req_y == self.y - 1 && (game.pieces.find_by(x: self.x - 1, y: self.y - 1).present?)
      end
    end
    return false
  end
end
