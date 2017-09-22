class Knight < Piece
  #method for this to use
  def check
    return "This is the knight"
  end

  def is_valid?(req_x,req_y)
    #checking if input is off the board
    return false if req_x < 1 or req_x > 8 or req_y < 1 or req_y > 8
    diff_x = (req_x - self.x).abs
    diff_y = (req_y - self.y).abs
    #checks if there is no vertical or horizontal movement or the movement if too far
    return false if diff_x == 0 or diff_y == 0 or diff_x + diff_y != 3
    return true
  end
end
