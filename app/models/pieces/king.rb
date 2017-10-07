class King < Piece
  #method for this to use
  def check
    return "This is the king"
  end


  def is_valid?(req_x, req_y)
    return false if self.check?(req_x,req_y)
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
    if self.can_castle?(req_x, req_y) && !self.check? && !self.check?(req_x,req_y)
      castle_rook_x = req_x == 7 ? 8 : 1
      castle_rook_to_move = req_x == 7 ? 6 : 4
      self.update_attributes(x:req_x)
      self.game.find_one_in_game(x:castle_rook_x,y:self.y,type:'Rook').update_attributes(x:castle_rook_to_move)
      #Piece.where("game_id = ? AND x = ? AND y = ? and type = 'Rook'",self.game_id,castle_rook_x,self.y).take.update_attributes(x:castle_rook_to_move)
    end
  end

  def check?(req_x = self.x,req_y = self.y)
    opposing_color = self.color == "white" ? "black" : "white"

    #iterate through the opposing pieces for check on the king
    pieces = self.game.find_in_game(color: opposing_color, active: true).to_a
    pieces.each do |piece|
      if piece.valid_move?(req_x, req_y)
        return true
      end
    end
    return false
  end
end
