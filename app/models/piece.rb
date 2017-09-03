class Piece < ApplicationRecord
  belongs_to :game

  enum color: {white: 0, black: 1}
end
