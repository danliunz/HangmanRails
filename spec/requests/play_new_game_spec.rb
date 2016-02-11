require "rails_helper"

RSpec.describe "Game play", type: :request do
  def player_create_new_game
    get "/games"
    expect(response).to have_http_status(200)
    assert_select "form button[type=submit]", "Create New Game"
    
    post "/games"
    new_game = Game.order(id: :desc).limit(1).first
    expect(response).to redirect_to(game_url(new_game))
    
    follow_redirect!
    expect(response).to have_http_status(:ok)
    assert_select ".game-secret"
    assert_select ".game-input"
    assert_select "form[action=?] input[name=?]", 
                  submit_guess_path(new_game), "guess"
    
    new_game
  end
  
  def player_win_by_making_all_right_guesses(game)
    right_guesses = game.secret.chars.uniq
    
    right_guesses.each do |guess|
      post submit_guess_path(game), { :guess => guess }
      expect(response).to redirect_to(game_url(game))
      
      follow_redirect!
      if guess == right_guesses.last
        assert_select ".game-status div", "Game Won"
      else
        expect(css_select(".game-status div")).to be_empty
      end
    end
  end
  
  it "allows player to create new game and win it" do
    game = player_create_new_game
    player_win_by_making_all_right_guesses(game)
  end
  
end
