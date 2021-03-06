class Piece < ApplicationRecord
  belongs_to :game

  enum color: {white: 0, black: 1}

  # req_x and req_y are coordinates/integers
  def is_obstructed?(req_x, req_y)
    return false if self.type == "Knight"

    if self.requested_position_north(req_x, req_y)
        return true if game.pieces.where("x = ? AND y > ? AND y < ?", self.x, self.y, req_y).present?
    elsif self.requested_position_south(req_x, req_y)
        return true if game.pieces.where("x = ? AND y < ? AND y > ?", self.x, self.y, req_y).present?
    elsif self.requested_position_east(req_x, req_y)
        return true if game.pieces.where("y = ? AND x > ? AND x < ?", self.y, self.x, req_x).present?
    elsif self.requested_position_west(req_x, req_y)
        return true if game.pieces.where("y = ? AND x < ? AND x > ?", self.y, self.x, req_x).present?
    elsif self.requested_position_northeast(req_x, req_y)
      return true if find_obstructions_on_diagonal(req_x, req_y)
    elsif self.requested_position_northwest(req_x, req_y)
      return true if find_obstructions_on_diagonal(req_x, req_y)
    elsif self.requested_position_southwest(req_x, req_y)
      return true if find_obstructions_on_diagonal(req_x, req_y)
    else #requested_position_southeast(req_x, req_y)
      return true if find_obstructions_on_diagonal(req_x, req_y)
    end

    return false
  end

  def find_obstructions_on_diagonal(req_x, req_y)
    i = 1
    j = self.x
    k = self.y
    while i < (self.x - req_x).abs
      j += 1
      k += 1
      return true if game.pieces.where("x = ? AND y = ?", j, k).present?
      i += 1
    end
  end

  def requested_position_north(req_x, req_y)
    return true if (self.x == req_x) && (self.y < req_y)
    return false
  end

  def requested_position_south(req_x, req_y)
    return true if (self.x == req_x) && (self.y > req_y)
    return false
  end

  def requested_position_northeast(req_x, req_y)
    return true if ((self.x - req_x).abs == (self.y - req_y).abs) && (self.x < req_x && self.y < req_y)
    return false
  end

  def requested_position_southeast(req_x, req_y)
    return true if ((self.x - req_x).abs == (self.y - req_y).abs) && (self.x < req_x && self.y > req_y)
    return false
  end

  def requested_position_southwest(req_x, req_y)
    return true if ((self.x - req_x).abs == (self.y - req_y).abs) && (self.x > req_x && self.y > req_y)
    return false
  end

  def requested_position_northwest(req_x, req_y)
    return true if ((self.x - req_x).abs == (self.y - req_y).abs) && (self.x > req_x && self.y < req_y)
    return false
  end

  def requested_position_east(req_x, req_y)
    return true if (self.y == req_y) && (self.x < req_x)
    return false
  end

  def requested_position_west(req_x, req_y)
    return true if (self.y == req_y) && (self.x > req_x)
    return false
  end

  def move_to!(req_x, req_y)
    # return the 2nd piece (if it exists in the clicked cell)
    blocking_piece = game.pieces.find_by("x = ? AND y = ?", req_x, req_y)

    # if there is a 2nd piece,
    if blocking_piece
      # that is not the same color as the 1st piece,
      if blocking_piece.color != self.color
        # take the 2nd piece off the board and change its status to inactive
        blocking_piece.update(x: 0, y: 0, active: false)
        # move the 1st piece to the new spot
        self.update(x: req_x, y: req_y)
      end
    elsif self.type == "King" && (req_x - self.x).abs == 2
      self.castle!(req_x, req_y)
    else
      # if the clicked cell is empty then move the 1st piece there
      self.update(x: req_x, y: req_y)
    end
  end

  def same_team?(req_x, req_y)
    blocking_piece = self.game.find_one_piece_in_game(x:req_x,y:req_y)
    #blocking_piece = game.pieces.find_by("x = ? AND y = ?", req_x, req_y)
    return self.color == blocking_piece.color if blocking_piece
  end

  def off_board?(req_x, req_y)
    return true if req_x < 1 || req_x > 8 || req_y < 1 || req_y > 8
  end

  def move_results_in_check?
    return true if game.pieces.find_by(type: "King", color: color).check?
  end

  def valid_move?(req_x, req_y)
    return false if self.is_obstructed?(req_x, req_y)
    return false if !self.is_valid?(req_x, req_y)
    return false if self.same_team?(req_x, req_y)
    return false if self.off_board?(req_x, req_y)
    return true
  end
end
