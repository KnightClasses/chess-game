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
    game = self.game

    paths = {
      "north" => [],
      "east" => [],
      "south" => [],
      "west" => []
    }

    (y+1..8).each do |digit|
      piece_in_current_cell_exists = !game.pieces.find_by("x = ? AND y = ?", x, digit).nil?
      paths["north"] << [x, digit]
      break if piece_in_current_cell_exists
    end

    (x+1..8).each do |digit|
      piece_in_current_cell_exists = !game.pieces.find_by("x = ? AND y = ?", digit, y).nil?
      paths["east"] << [digit, y]
      break if piece_in_current_cell_exists
    end

    (y-1).downto(1) do |digit|
      piece_in_current_cell_exists = !game.pieces.find_by("x = ? AND y = ?", x, digit).nil?
      paths["south"] << [x, digit]
      break if piece_in_current_cell_exists
    end

    (x-1).downto(1) do |digit|
      piece_in_current_cell_exists = !game.pieces.find_by("x = ? AND y = ?", digit, y).nil?
      paths["west"] << [digit, y]
      break if piece_in_current_cell_exists
    end

    paths
  end
end
