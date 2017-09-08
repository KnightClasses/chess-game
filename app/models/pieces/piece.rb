class Piece < ApplicationRecord
  belongs_to :game

  enum color: {white: 0, black: 1}

  # req_x and req_y are coordinates/integers
  def is_obstructed?(req_x, req_y)
    if self.x == req_x # vertical
      j = self.y
      k = req_y
      if self.y < req_y # up
        return true if self.where("y > ? AND y < ?", j, k)
      else # down
        return true if self.where("y < ? AND y > ?", j, k)
      end

    elsif self.y == req_y # horizontal
      j = self.x
      k = req_x
      if self.x < req_x # to right
        return true if self.where("x > ? AND x < ?", j, k)
      else # to left
        return true if self.where("x < ? AND x > ?", j, k)
      end

    elsif (self.x - req_x).abs == (self.y - req_y).abs # diagonal
      if self.x < req_x && self.y < req_y # x increasing, y increasing
        i = 0
        j = self.x
        k = self.y
        while i < (self.x - req_x).abs
          j += 1
          k += 1
          return true if self.where("x = ? AND y = ?", j, k)
          i += 1
        end
      elsif self.x > req_x && self.y < req_y # x decreasing, y increasing
        i = 0
        j = self.x
        k = self.y
        while i < (self.x - req_x).abs
          j -= 1
          k += 1
          return true if self.where("x = ? AND y = ?", j, k)
          i += 1
        end
      elsif self.x > req_x && self.y > req_y # x decreasing, y decreasing
        i = 0
        j = self.x
        k = self.y
        while i < (self.x - req_x).abs
          j -= 1
          k -= 1
          return true if self.where("x = ? AND y = ?", j, k)
          i += 1
        end
      else # x increasing, y decreasing
        i = 0
        j = self.x
        k = self.y
        while i < (self.x - req_x).abs
          j += 1
          k -= 1
          return true if self.where("x = ? AND y = ?", j, k)
          i += 1
        end
      end

    else # invalid (temporarily disregarding knight)
      puts "invalid"
    end
  end
end
