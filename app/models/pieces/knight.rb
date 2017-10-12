class Knight < Piece

  def is_valid?(req_x,req_y)
    #checking if input is off the board
    return false if req_x < 1 || req_x > 8 || req_y < 1 || req_y > 8
    diff_x = (req_x - self.x).abs
    diff_y = (req_y - self.y).abs
    #checks if there is no vertical or horizontal movement or the movement if too far
    return false if diff_x == 0 || diff_y == 0 || diff_x + diff_y != 3
    return true
  end
end
