class Game < ApplicationRecord
  belongs_to :user, :foreign_key => "white_player_id"
  has_many :pieces
  scope :available, -> { where(black_player_id: nil) }
  after_create :populate_game!

  def populate_game!
    1.upto(8) do |x_pos|
      Pawn.create(game_id: id, x: x_pos, y: 2, color: 0)
    end

    1.upto(8) do |x_pos|
      Pawn.create(game_id: id, x: x_pos, y: 7, color: 1)
    end

    Rook.create(game_id: id, x: 1, y: 1, color: 0)
    Rook.create(game_id: id, x: 8, y: 1, color: 0)
    Rook.create(game_id: id, x: 1, y: 8, color: 1)
    Rook.create(game_id: id, x: 8, y: 8, color: 1)

    Knight.create(game_id: id, x: 7, y: 1, color: 0)
    Knight.create(game_id: id, x: 2, y: 1, color: 0)
    Knight.create(game_id: id, x: 7, y: 8, color: 1)
    Knight.create(game_id: id, x: 2, y: 8, color: 1)

    Bishop.create(game_id: id, x: 6, y: 1, color: 0)
    Bishop.create(game_id: id, x: 3, y: 1, color: 0)
    Bishop.create(game_id: id, x: 6, y: 8, color: 1)
    Bishop.create(game_id: id, x: 3, y: 8, color: 1)

    Queen.create(game_id: id, x: 4, y: 1, color: 0)
    Queen.create(game_id: id, x: 4, y: 8, color: 1)

    King.create(game_id: id, x: 5, y: 1, color: 0)
    King.create(game_id: id, x: 5, y: 8, color: 1)
  end

end
