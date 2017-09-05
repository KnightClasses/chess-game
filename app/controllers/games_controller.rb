class GamesController < ApplicationController
  def index
  end

  def new
    @game = Game.new
  end
end
