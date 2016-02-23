class GuessesController < ApplicationController
  def create
   @game = Game.find(params[:game_id])
   
   @guess = MakeGuess.new(@game, params[:guess]).call
   if @guess.errors.any?
     flash[:alert] = @guess.errors.full_messages.join("\n")
   end
   
   redirect_to game_url(@game)
  end
  
  private
  
  def bring_game_to_top_of_history
    @game.touch
  end
end