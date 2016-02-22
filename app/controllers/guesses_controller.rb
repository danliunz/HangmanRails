class GuessesController < ApplicationController
  def create
   @game = Game.find(params[:game_id])
   
   @guess = SubmitGuess.call(@game, params[:guess])
   if @guess.errors.empty?
     bring_game_to_top_of_history
   else
     flash[:alert] = @guess.errors.full_messages.join("\n")
   end
   
   redirect_to game_url(@game)
  end
  
  private
  
  def bring_game_to_top_of_history
    @game.touch
  end
end