require "time"

class GamesController < ApplicationController
  before_action :load_game, only: :show
  
  def index
    @games = Game
      .paginate(page: params[:page], per_page: 10)
      .order(updated_at: :desc)
  end
  
  def show
  end
  
  def create
    # TODO: constant name = > lives?
    game = Game.new(
      secret: ChooseRandomWord.call,
      max_misses: Game::Config::MAX_GUESS_MISS
    )
    
    if game.save
      redirect_to game_url(game)
    else
      redirect_to games_url, alert: "Fail to create new game"
    end
  end
 
  private
  
  def load_game
    @game = GamePresenter.new(Game.find(params[:id]))
  end
end
