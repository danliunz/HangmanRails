require "time"

class GamesController < ApplicationController
  before_action :load_game, only: :show

  def index
    @games = Game
      .paginate(page: params[:page], per_page: 10)
      .ordered_by_last_play_time_desc
  end

  def show
  end

  def create
    game = Game.new(
      secret: ChooseRandomWord.new.call,
      initial_number_of_lives: Game::Config::INITIAL_NUMBER_OF_LIVES
    )

    if game.save
      redirect_to game
    else
      redirect_to games_url, alert: "Fail to create new game"
    end
  end

  private

  def load_game
    @game = Game.find(params[:id])
  end
end
