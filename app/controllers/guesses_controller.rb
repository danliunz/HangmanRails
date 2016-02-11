class GuessesController < ApplicationController
  def create
   @game = Game.find(params[:game_id])
   @guess = @game.submit_guess(params[:guess])
   if @guess.valid?
     # it should be brought to the beginning of game history 
     @game.touch
      
     redirect_to game_url(@game)
   else
     @game.guesses.delete(@guess)
     render "games/show"
   end
  end
end