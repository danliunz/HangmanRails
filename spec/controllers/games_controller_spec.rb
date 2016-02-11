require "rails_helper"

RSpec.describe GamesController, type: :controller do
  describe "POST #create" do
    it "redirects to URL for the newly created game" do
      post :create
      
      new_game = Game.order(id: :desc).limit(1).first
      expect(response).to redirect_to(game_url(new_game))
    end
  end
  
  describe "GET #show" do
    fixtures :games
    
    it "assigns @game of specified id" do
      game = games(:dragon)
      get :show, { id: game.id }
      
      expect(response).to have_http_status(200)
      expect(response).to render_template(:show)
      expect(assigns[:game]).to eq(game)
    end
  end
  
  describe "GET #index" do
    fixtures :games
    
    it "renders index template with @games assigned" do
      get :index
      
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
      
      expect(assigns[:games].size).to eq(1)
      expect(assigns[:games].first).to eq(games(:dragon))
    end
  end
end
