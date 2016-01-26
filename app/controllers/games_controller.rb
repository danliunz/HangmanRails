require "time"

class GamesController < ApplicationController
  before_action :load_active_game, 
                only: [:dash_board, :show_active_game, :submit_guess]
                
  before_action :active_game_must_exist, 
                only: [:show_active_game, :submit_guess]

  def dash_board
  end
  
  def create
    new_game = Game.new(secret: ChooseRandomWord.call,
                        max_misses: Game::Config::MAX_GUESS_MISS)
    new_game.save!
    
    session[:active_game] = new_game
    
    redirect_to active_game_url
  end
  
  def show_active_game
  end
  
  def submit_guess
    guess = params[:guess][:content]
    
    if (guess =~ /^[[:alpha:]]$/).nil?
      redirect_to active_game_url, notice: "Guess #{guess} is not single alphabetic character"
    else
      @active_game.submit_guess(guess)
      @active_game.save!
      redirect_to active_game_url
    end
  end
  
  private
  
  def load_active_game
    @active_game ||= session[:active_game]
  end
  
  def active_game_must_exist
    if @active_game.nil? 
      redirect_to games_url, notice: "Must start a game first"
    end
  end
end
