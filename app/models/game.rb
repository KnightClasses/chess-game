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

  def initial_player_turn
    self.update(player_turn: self.white_player_id)
  end

  def change_player_turn
    other_player = self.player_turn == self.white_player_id ? self.black_player_id : self.white_player_id
    self.update(player_turn: other_player)
  end

  def player_turn_color
    white = self.white_player_id
    self.player_turn == white ? "White" : "Black"
  end
end
