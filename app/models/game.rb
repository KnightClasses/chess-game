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

    if king.check?
      return false if (
        player_turn_color == color &&
        (king_can_move_and_prevent_checkmate?(color) ||
        (threatening_pieces?(color).count == 1 &&
        (threatening_piece_may_be_blocked_by_teammate?(color) ||
        (threatening_piece_may_be_captured_by_teammate?(color) ) ) ) ) )
      return true
    end

    return false
  end

  def king_can_move_and_prevent_checkmate?(color)
    king = self.pieces.find_by(type: "King", color: color)
    #iterate through all possible moves (8 possible moves in perimeter of king) for a safe spot (no checkmate)
    left = king.x - 1
    right = king.x + 1
    bottom = king.y - 1
    top = king.y + 1

    (left..right).each do |row|
      (bottom..top).each do |column|
        # if moving to the spot is valid,
         if king.is_valid?(row, column) && !king.same_team?(row, column) && !king.off_board?(row, column)
          # and if moving to any of the spots results in NOT being in check,
          if !king.check?(row, column)
            return true ## king can safely move there
          end
        end
      end
    end
    return false ## no such safe spot exists for the king to move itself to
  end

  def threatening_pieces?(color) ## finds all pieces that are holding the king(color) in check
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
    threatening_pieces = threatening_pieces?(color)
    king = self.pieces.find_by(type: "King", color: color)
    teammate_pieces = self.pieces.where(color: color, active: true).where.not(type: "King").to_a

    # if there is more than 1 threatening piece, it doesn't matter if you can block one of them
    # because the other one(s) can capture the king on the next move
    if threatening_pieces.length == 1
      threatening_piece = threatening_pieces[0]

      # check each capture path for this threatening piece
      threatening_piece.capture_path.values.each do |path|

        # find which path the king is on
        if path.include?([king.x, king.y])
          king_is_on_this_path = path
        else
          next
        end

        # go through each of pieces on your own team
        teammate_pieces.each do |teammate_piece|

          # go through each of the cells between the threatening piece and the king
          king_is_on_this_path.each do |cell|

            # if a teammate piece may move to any of the cells along this path, the threat CAN be BLOCKED
            return true if teammate_piece.valid_move?(cell[0], cell[1])
          end
        end

        # the threat cannot be blocked
        return false
      end
    end

    # there are more than 1 threatening pieces
    return false
  end
end
