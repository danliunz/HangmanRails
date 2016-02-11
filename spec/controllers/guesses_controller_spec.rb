require "rails_helper"

RSpec.describe GuessesController, type: :controller do
  describe "POST #create" do
    fixtures :games
    let(:game) { games(:dragon) }
    
    it "redirects to show game if guess submission succeeds" do
      post :create, { game_id: game.id, guess: "d" }
      expect(response).to redirect_to(game_url(game))
    end
    
    it "redirect to show game with error msg if guess is invalid" do
      post :create, { game_id: game.id, guess: "1"}
      
      expect(response).to redirect_to(game_url(game))
      expect(flash[:alert]).not_to be_empty
    end
  end
end