class Game < ApplicationRecord
  belongs_to :user
  has_many :pieces
  scope :available, -> { where(black_player: nil) }
end
