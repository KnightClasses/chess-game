class Bishop < Piece

  def is_valid?(req_x, req_y)
    return true if (self.x - req_x).abs == (self.y - req_y).abs

    return false
  end

  def capture_path
    x = self.x
    y = self.y
    game = self.game

    paths = {
      "northeast" => [],
      "southeast" => [],
      "southwest" => [],
      "northwest" => []
    }

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
