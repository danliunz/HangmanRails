class GuessesController < ApplicationController
  def create
   @game = Game.find(params[:game_id])
   
   @guess = @game.submit_guess(params[:guess])
   if @guess.valid?
     bring_game_to_top_of_history
   else
     flash[:alert] = @guess.errors.full_messages.first
     @game.guesses.delete(@guess)
   end
   
   redirect_to game_url(@game)
  end
  
  private
  
  def bring_game_to_top_of_history
    @game.touch
  end
end