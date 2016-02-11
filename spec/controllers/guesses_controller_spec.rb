require "rails_helper"

RSpec.describe GuessesController, type: :controller do
  describe "POST #create" do
    fixtures :games
    let(:game) { games(:dragon) }
    
    it "redirects to game url if guess submission succeeds" do
      post :create, { game_id: game.id, guess: "d" }
      expect(response).to redirect_to(game_url(game))
    end
    
    it "renders game/show template with error msg" do
      post :create, { game_id: game.id, guess: "1"}
      
      expect(response).to have_http_status(:ok)
      expect(response).to render_template("games/show")
      
      expect(assigns[:game]).to eq(game)
      expect(assigns[:guess].letter).to eq("1")
    end
  end
end