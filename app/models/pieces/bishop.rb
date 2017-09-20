class Bishop < Piece
  #method for this to use
  def check
    return "This is the bishop"
  end

  def is_valid(move_x, move_y)
    horizontal = []
    vertical = []
    point = [move_x, move_y]


    for i in 1..8 
        horizontal << [i, self.y]    
    end

    for i in 1..8
        vertical << [self.x, i]
    end

    all = horizontal + vertical


    if all.include?(point)
        return true
    else
      return false
    end
  end
end
