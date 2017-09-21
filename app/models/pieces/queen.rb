class Queen < Piece
  #method for this to use
  def check
    return "This is the queen"
  end

<<<<<<< HEAD
  def is_valid?(req_x, req_y)
    if (req_x == self.x || req_y == self.y) || ((req_x - self.x).abs == (req_y - self.y).abs)
        return true
    else
        return false
    end
  end
=======
   def is_valid (req_x, req_y)
        if (req_x == self.x || req_y == self.y) || (req_x - self.x === req_y - self.y) 
            return true
        else
            return false
      end
    end
>>>>>>> 3bc68afda86b60ed3d1b5722f23318d7ac9c93db

end
