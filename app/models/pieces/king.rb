class King < Piece
  #method for this to use
  def check
    return "This is the king"
  end


  def is_valid?(req_x, req_y)
    return true if (req_x - self.x).abs <= 1 && (req_y - self.y).abs <= 1

    return false
  end

  def can_castle?
    #returns true if unmoved
    return true if self.updated_at == self.created_at 
  end

  def castle!(req_y)
    #alter this section when in_check is complete
    in_check = false
    self.update_attributes(x:self.x,y:self.y);return unless self.can_castle? || in_check
    search_params = "x = #{req_y == 7 ? 8 : 1} AND y = #{self.y} AND game_id = #{self.game_id} AND type = 'Rook'"
    castle_rook = Piece.where(search_params)
    if castle_rook.can_castle? do 
      castle_rook.update_attributes(y:req_y == 7 ? 6 : 4)
      self.update_attributes(y:req_y)
    end
  end
end
