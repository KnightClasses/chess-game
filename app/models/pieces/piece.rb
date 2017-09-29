class Piece < ApplicationRecord
  belongs_to :game

  enum color: {white: 0, black: 1}

  # req_x and req_y are coordinates/integers
  def is_obstructed?(req_x, req_y, current_game_id)
    if self.x == req_x # vertical
      h = self.x
      j = self.y
      k = req_y
      if self.y < req_y # up
        return true if Piece.where("x = ? AND y > ? AND y < ? AND game_id = ?", h, j, k, game_id).present?
      else # down
        return true if Piece.where("x = ? AND y < ? AND y > ? AND game_id = ?", h, j, k, game_id).present?
      end

    elsif self.y == req_y # horizontal
      h = self.y
      j = self.x
      k = req_x
      if self.x < req_x # to right
        return true if Piece.where("y = ? AND x > ? AND x < ? AND game_id = ?", h, j, k, game_id).present?
      else # to left
        return true if Piece.where("y = ? AND x < ? AND x > ? AND game_id = ?", h, j, k, game_id).present?
      end

    elsif (self.x - req_x).abs == (self.y - req_y).abs # diagonal
      if self.x < req_x && self.y < req_y # x increasing, y increasing
        i = 0
        j = self.x
        k = self.y
        while i < (self.x - req_x).abs
          j += 1
          k += 1
          return true if Piece.where("x = ? AND y = ? AND game_id = ?", j, k, game_id).present?
          i += 1
        end
      elsif self.x > req_x && self.y < req_y # x decreasing, y increasing
        i = 0
        j = self.x
        k = self.y
        while i < (self.x - req_x).abs
          j -= 1
          k += 1
          return true if Piece.where("x = ? AND y = ? AND game_id = ?", j, k, game_id).present?
          i += 1
        end
      elsif self.x > req_x && self.y > req_y # x decreasing, y decreasing
        i = 0
        j = self.x
        k = self.y
        while i < (self.x - req_x).abs
          j -= 1
          k -= 1
          return true if Piece.where("x = ? AND y = ? AND game_id = ?", j, k, game_id).present?
          i += 1
        end
      else # x increasing, y decreasing
        i = 0
        j = self.x
        k = self.y
        while i < (self.x - req_x).abs
          j += 1
          k -= 1
          return true if Piece.where("x = ? AND y = ? AND game_id = ?", j, k, game_id).present?
          i += 1
        end
      end

    elsif self.type == "Knight"
      return false

    else # invalid move
      return "invalid move"
    end

    return false
  end

  def move_to!(req_x, req_y, current_game_id)
    # return the 2nd piece (if it exists in the clicked cell)
    blocking_piece = Piece.find_by("x = ? AND y = ? AND game_id = ?", req_x, req_y, current_game_id)

    # if there is a 2nd piece,
    if blocking_piece
      # that is not the same color as the 1st piece,
      if blocking_piece.color != self.color
        # take the 2nd piece off the board and change its status to inactive
        blocking_piece.update(x: 0, y: 0, active: false)
        # move the 1st piece to the new spot
        self.update(x: req_x, y: req_y)
      end
    else
      # if the clicked cell is empty then move the 1st piece there
      self.update(x: req_x, y: req_y)
    end
  end

  def same_team?(req_x, req_y, current_game_id)
    blocking_piece = Piece.find_by("x = ? AND y = ? AND game_id = ?", req_x, req_y, current_game_id)
    return self.color == blocking_piece.color if blocking_piece
  end
end
