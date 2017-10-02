class Game < ApplicationRecord
  belongs_to :user, :foreign_key => "white_player_id"
  has_many :pieces
  scope :available, -> { where(black_player_id: nil) }
  after_create :populate_game!

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

  def all_from_current_game(args = {})
    return Piece.where("game_id = ?", self.id) if args == {}
    Piece.where("game_id = ? AND #{write_sql_search(args)}",self.id)
  end

  def one_from_current_game(args = {})
    return Piece.where("game_id = ?", self.id).take(1) if args == {}
    Piece.where("game_id = ? AND #{write_sql_search(args)}",self.id).take(1)
  end

  private

  def write_sql_search(args)
    queries = []
    queries << (args.fetch(:x,false) ? "x = #{args[:x]}" : "")
    queries << (args.fetch(:y,false) ? "y = #{args[:y]}" : "")
    queries << (args.fetch(:type,false) ? "type = '#{args[:type].capitalize}'" : "")
    queries << (args.fetch(:color,false) ? "color = #{(args[:color].capitalize == "White" ? 0 : 1)}" : "")
    full_statement = queries.reduce {|sum,x| x != ""? sum.concat(" AND #{x}") : sum}
    full_statement[5..full_statement.length]
  end
end
