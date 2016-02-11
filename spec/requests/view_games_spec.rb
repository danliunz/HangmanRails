require "rails_helper"

RSpec.describe "Viewing games" do
  fixtures :games
  let(:game) { games(:dragon) }
  
  def expect_the_only_game_in_history_is_resumable
    assert_select ".game-history tbody tr", 1
    
    assert_select ".game-history tbody tr:first-child" do
      assert_select "td:nth-child(3) a[href=?]", game_path(game)
      assert_select "td:nth-child(3) a", /resume/i
    end
  end
  
  def expect_game_secret_obsecure_to_player
    assert_select ".game-secret .label", "_"
  end
  
  def expect_player_able_to_submit_all_letters_as_guess
    ("a" .. "z").each do |letter|
      letter_tags = css_select(".game-input .btn:content(?)", letter)
      expect(letter_tags.length).to eq(1)
      
      letter_tag = letter_tags.first
      expect(letter_tag["invisible"]).to be_nil
      expect(letter_tag["disabled"]).to be_nil
    end
  end
  
  def expect_hidden_form_to_submit_guess
    assert_select ".game-input #submit_guess_form"
  end
  
  it "allows player to view game history and check specific game's detail" do
    get "/games"
    expect(response).to have_http_status(:ok)
    expect_the_only_game_in_history_is_resumable
    
    get "/games/#{game.id}"
    expect(response).to have_http_status(:ok)
    expect_game_secret_obsecure_to_player
    expect_player_able_to_submit_all_letters_as_guess
    expect_hidden_form_to_submit_guess
  end
end
