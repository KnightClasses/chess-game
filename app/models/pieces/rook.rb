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
    x = self.x
    y = self.y

    paths = {
      "north" => [],
      "east" => [],
      "south" => [],
      "west" => []
    }

    (1..8).each do |digit|

      if digit < y
        paths["south"] << [x, digit]
      elsif digit > y
        paths["north"] << [x, digit]
      end

      if digit < x
        paths["west"] << [digit, y]
      elsif digit > x
        paths["east"] << [digit, y]
      end
    end
    paths
  end
end
