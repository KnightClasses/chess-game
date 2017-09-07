class Game < ApplicationRecord
  belongs_to :white_player, class_name: "User"
  has_many :pieces
end
