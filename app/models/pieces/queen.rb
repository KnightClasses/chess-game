class Queen < Piece
  #method for this to use
  def check
    return "This is the queen"
  end

  def is_valid?(req_x, req_y)
    if  ((req_x - self.x).abs == (req_y - self.y).abs) || (req_x == self.x || req_y == self.y)
        return true
    else
        return false
    end
  end

  def capture_path
    x = self.x
    y = self.y
    game = self.game

    paths = {
      "north" => [],
      "east" => [],
      "south" => [],
      "west" => [],
      "northeast" => [],
      "southeast" => [],
      "southwest" => [],
      "northwest" => []
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

    ## determine whether x or y will reach the game board edge first (top, right, bottom, left edges), and save it in a variable
    x_dist_from_right_or_top_edge = 8-x
    y_dist_from_right_or_top_edge = 8-y
    x_dist_from_left_or_bottom_edge = x-1
    y_dist_from_left_or_bottom_edge = y-1

    if x_dist_from_right_or_top_edge < y_dist_from_right_or_top_edge
      do_this_many_times = x_dist_from_right_or_top_edge
    else
      do_this_many_times = y_dist_from_right_or_top_edge
    end

    (do_this_many_times+1).times do |increment|
      if increment > 0
        piece_in_current_cell_exists = !game.pieces.find_by("x = ? AND y = ?", x + increment, y + increment).nil?
        paths["northeast"] << [x + increment, y + increment]
        break if piece_in_current_cell_exists
      end
    end

    if x_dist_from_right_or_top_edge < y_dist_from_left_or_bottom_edge
      do_this_many_times = x_dist_from_right_or_top_edge
    else
      do_this_many_times = y_dist_from_left_or_bottom_edge
    end

    (do_this_many_times+1).times do |increment|
      if increment > 0
        piece_in_current_cell_exists = !game.pieces.find_by("x = ? AND y = ?", x + increment, y - increment).nil?
        paths["southeast"] << [x + increment, y - increment]
        break if piece_in_current_cell_exists
      end
    end

    if x_dist_from_left_or_bottom_edge < y_dist_from_left_or_bottom_edge
      do_this_many_times = x_dist_from_left_or_bottom_edge
    else
      do_this_many_times = y_dist_from_left_or_bottom_edge
    end

    (do_this_many_times+1).times do |increment|
      if increment > 0
        piece_in_current_cell_exists = !game.pieces.find_by("x = ? AND y = ?", x - increment, y - increment).nil?
        paths["southwest"] << [x - increment, y - increment]
        break if piece_in_current_cell_exists
      end
    end

    if x_dist_from_left_or_bottom_edge < y_dist_from_right_or_top_edge
      do_this_many_times = x_dist_from_left_or_bottom_edge
    else
      do_this_many_times = y_dist_from_right_or_top_edge
    end

    (do_this_many_times+1).times do |increment|
      if increment > 0
        piece_in_current_cell_exists = !game.pieces.find_by("x = ? AND y = ?", x - increment, y + increment).nil?
        paths["northwest"] << [x - increment, y + increment]
        break if piece_in_current_cell_exists
      end
    end

    paths
  end
end
