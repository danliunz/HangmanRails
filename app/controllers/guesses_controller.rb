class GuessesController < ApplicationController
  def create
    game = Game.find(params[:game_id])

    make_guess = MakeGuess.new(game, params[:guess])
    unless make_guess.call
       flash[:alert] = make_guess.error_message
    end

    redirect_to game
  end
end