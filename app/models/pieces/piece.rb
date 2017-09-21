class Piece < ApplicationRecord
  belongs_to :game

  enum color: {white: 0, black: 1}

  # req_x and req_y are coordinates/integers
  def is_obstructed?(req_x, req_y)
    if self.x == req_x # vertical
      j = self.y
      k = req_y
      if self.y < req_y # up
        return true if Piece.where("y > ? AND y < ?", j, k).present?
      else # down
        return true if Piece.where("y < ? AND y > ?", j, k).present?
      end

    elsif self.y == req_y # horizontal
      j = self.x
      k = req_x
      if self.x < req_x # to right
        return true if Piece.where("x > ? AND x < ?", j, k).present?
      else # to left
        return true if Piece.where("x < ? AND x > ?", j, k).present?
      end

    elsif (self.x - req_x).abs == (self.y - req_y).abs # diagonal
      if self.x < req_x && self.y < req_y # x increasing, y increasing
        i = 0
        j = self.x
        k = self.y
        while i < (self.x - req_x).abs
          j += 1
          k += 1
          return true if Piece.where("x = ? AND y = ?", j, k).present?
          i += 1
        end
      elsif self.x > req_x && self.y < req_y # x decreasing, y increasing
        i = 0
        j = self.x
        k = self.y
        while i < (self.x - req_x).abs
          j -= 1
          k += 1
          return true if Piece.where("x = ? AND y = ?", j, k).present?
          i += 1
        end
      elsif self.x > req_x && self.y > req_y # x decreasing, y decreasing
        i = 0
        j = self.x
        k = self.y
        while i < (self.x - req_x).abs
          j -= 1
          k -= 1
          return true if Piece.where("x = ? AND y = ?", j, k).present?
          i += 1
        end
      else # x increasing, y decreasing
        i = 0
        j = self.x
        k = self.y
        while i < (self.x - req_x).abs
          j += 1
          k -= 1
          return true if Piece.where("x = ? AND y = ?", j, k).present?
          i += 1
        end
      end

    else # invalid move (temporarily disregarding knight)
      return "invalid move"
    end

    return false
  end

  def move_to!(req_x, req_y, current_game_id)
    @alert_message = ""
    # return the piece (if it exists in the clicked cell)
    blocking_piece = Piece.find_by("x = ? AND y = ? AND game_id = ?", req_x, req_y, current_game_id)

    # if there is a piece,
    if blocking_piece
      # that is not the same color,
      if blocking_piece.color != self.color
        # take it off the board and change its status to inactive
        blocking_piece.update(x: 0, y: 0, active: false)
        self.update(x: req_x, y: req_y)
      else
        # need some sort of alert saying "You can not capture your own piece. Please try again."
      end
    else
      # if the clicked cell is empty then move the piece there
      self.update(x: req_x, y: req_y)
    end
  end


  def same_team?(req_x, req_y, req_color)
    return self.color == req_color
  end
end
