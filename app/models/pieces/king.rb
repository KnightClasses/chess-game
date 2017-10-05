class King < Piece
  #method for this to use
  def check
    return "This is the king"
  end


  def is_valid?(req_x, req_y)
    return true if (req_x - self.x).abs == 2 && self.can_castle?(req_x, req_y)
    return true if (req_x - self.x).abs <= 1 && (req_y - self.y).abs <= 1

    return false
  end

  def unmoved(piece)
    return false if piece == nil
    return true if piece.updated_at == piece.created_at
    return false
  end

  def can_castle?(req_x, req_y)
    #returns true if unmoved
    return false if req_x != 7 && req_x != 3
    return false if req_y != self.y
    castle_rook_x = req_x == 7 ? 8 : 1 
    return true if unmoved(self) && unmoved(self.game.find_one_in_game(x:castle_rook_x,y:self.y,type:'Rook'))
    #return true if unmoved(self) && unmoved(Piece.where("game_id = ? AND x = ? AND y = ? and type = 'Rook'",self.game_id,castle_rook_x,self.y).take)
    return false
  end

  def castle!(req_x, req_y)
    unless self.can_castle?(req_x, req_y) && !self.game.in_check?(self.color)
      self.update_attributes(x:self.x,y:self.y) 
      return
    end
    castle_rook_x = req_x == 7 ? 8 : 1
    castle_rook_to_move = req_x == 7 ? 6 : 4
    self.update_attributes(x:req_x)
    self.game.find_one_in_game(x:castle_rook_x,y:self.y,type:'Rook').update_attributes(x:castle_rook_to_move)
    #Piece.where("game_id = ? AND x = ? AND y = ? and type = 'Rook'",self.game_id,castle_rook_x,self.y).take.update_attributes(x:castle_rook_to_move)
  end
end
