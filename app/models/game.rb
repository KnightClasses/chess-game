class Game < ApplicationRecord
  belongs_to :user, :foreign_key => "white_player_id"
  has_many :pieces
  scope :available, -> { where(black_player_id: nil) }
  after_create :populate_game!, :initial_player_turn

  def populate_game!
    1.upto(8) do |x_pos|
      Pawn.create(game_id: id, x: x_pos, y: 2, color: "white")
    end

    1.upto(8) do |x_pos|
      Pawn.create(game_id: id, x: x_pos, y: 7, color: "black")
    end

    Rook.create(game_id: id, x: 1, y: 1, color: "white")
    Rook.create(game_id: id, x: 8, y: 1, color: "white")
    Rook.create(game_id: id, x: 1, y: 8, color: "black")
    Rook.create(game_id: id, x: 8, y: 8, color: "black")

    Knight.create(game_id: id, x: 7, y: 1, color: "white")
    Knight.create(game_id: id, x: 2, y: 1, color: "white")
    Knight.create(game_id: id, x: 7, y: 8, color: "black")
    Knight.create(game_id: id, x: 2, y: 8, color: "black")

    Bishop.create(game_id: id, x: 6, y: 1, color: "white")
    Bishop.create(game_id: id, x: 3, y: 1, color: "white")
    Bishop.create(game_id: id, x: 6, y: 8, color: "black")
    Bishop.create(game_id: id, x: 3, y: 8, color: "black")

    Queen.create(game_id: id, x: 4, y: 1, color: "white")
    Queen.create(game_id: id, x: 4, y: 8, color: "black")

    King.create(game_id: id, x: 5, y: 1, color: "white")
    King.create(game_id: id, x: 5, y: 8, color: "black")
  end

  def clear_current_board
    Piece.where("game_id = ?",self.id).destroy_all
  end

  def find_in_game(**args)
    return self.pieces.where(game_id: self.id) if args == {}
    if args[:type] != nil
      args[:type] = args[:type].capitalize
    end
    if args[:color] != nil
      args[:color].downcase == "white" ? args[:color] = 0 : args[:color] = 1
    end
    self.pieces.where(args,game_id:self.id)
  end

  def find_one_in_game(**args)
    return self.pieces.where(game_id: self.id).take if args == {}
    if args[:type] != nil
      args[:type] = args[:type].capitalize
    end
    if args[:color] != nil
      args[:color].downcase == "white" ? args[:color] = 0 : args[:color] = 1
    end
    self.pieces.where(args,game_id:self.id).take
  end

# determines if king with given color is in check
  def in_check?(color)
    # find the king with the given color
    if color == 'white'
      opposing_color = 'black'
    else
      opposing_color = 'white'
    end

    king = self.pieces.find_by(type: "King", color: color)

    #iterate through the opposing pieces for check on the king
    pieces = self.pieces.where(color: opposing_color, active: true).to_a
    pieces.each do |piece|
      if piece.valid_move?(king.x, king.y)
        return true
      end
    end
    return false
  end

  def threatening_pieces?(color)
    # find the king with the given color
    if color == 'white'
      opposing_color = 'black'
    else
      opposing_color = 'white'
    end

    king = self.pieces.find_by(type: "King", color: color)
    threatening_pieces = []

    #iterate through the opposing pieces for check on the king
    pieces = self.pieces.where(color: opposing_color, active: true).to_a
    pieces.each do |piece|
      if piece.valid_move?(king.x, king.y)
        threatening_pieces << piece
      end
    end
    return threatening_pieces
  end

  def initial_player_turn
    self.update(player_turn: self.white_player_id)
  end

  def change_player_turn
    other_player = self.player_turn == self.white_player_id ? self.black_player_id : self.white_player_id
    self.update(player_turn: other_player)
  end

  def player_turn_color
    white = self.white_player_id
    self.player_turn == white ? "white" : "black"
  end

  def checkmate?(color)
    king = self.pieces.find_by(type: "King", color: color)
    game = king.game

    if king.check? ## if king is in check,
      #iterate through all possible moves (9 possible moves in perimeter of king) for checkmate
      x = king.x
      y = king.y
      left = king.x - 1
      right = king.x + 1
      bottom = king.y - 1
      top = king.y + 1

      (left..right).each do |row|
        (bottom..top).each do |column|
          # if moving to the spot is valid,
          if king.is_valid?(row, column) && !king.off_board?(row, column)
            # and if moving to any of the spots results in NOT being in check,
            if !king.check?(row, column)
              return false
            end
          end
        end
      end
      return false if game.threatening_piece_may_be_captured_by_teammate?(color) && color == player_turn_color
      return true
    end
  end

  def threatening_piece_may_be_captured_by_teammate?(color)
    king = self.pieces.find_by(type: "King", color: color)
    game = king.game
    game_id = game.id
    pieces = king.game.find_in_game(color: color, active: true).to_a
    threatening_pieces = threatening_pieces?(color)

    threatening_pieces.each do |threatening_piece|
      pieces.each do |piece|
        if piece.valid_move?(threatening_piece.x, threatening_piece.y)
          return true
        end
      end
    end
    return false
  end

  def threatening_piece_may_be_blocked_by_teammate?(color)
    # ghost_piece = Piece.create(game_id: game_id)

    # go through each cell on the gameboard
    # (1..8).each do |row|
    #   (1..8).each do |column|
        # if having a piece from your own team in this cell changes the condition of king.checkmate? to false,
        # ghost_piece.x = row
        # ghost_piece.y = column
        # if game.checkmate?(color) == false
        #   #   cycle thru all valid pieces
        #   pieces = game.find_in_game(color: color, active: true).to_a
        #   pieces.each do |piece|
        #     #   check each piece see if piece.valid_move?
        #     if piece.valid_move?(row, column)
        #       #   if TRUE, then return true
        #       return true
        #     end
        #   end
        #   return false
        # end
    #   end
    # end
    # pieces = self.game.find_in_game(color: opposing_color, active: true).to_a
    # pieces.each do |piece|
    #   if piece.valid_move?(req_x, req_y)
    #     return true
    #   end
    # end
    # return false
  end
end
