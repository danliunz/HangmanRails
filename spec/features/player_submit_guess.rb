require "rails_helper"

feature "Guess submission", :js => true do
  fixtures :games
  let(:game) { games(:dragon) }
  
  def visit_game_detail_page
    visit "/games/#{game.id}"
  end
  
  def expect_game_secret_obscured
    expect(page).to have_content("word to guess")
    all(".game-secret .label").each do |secret_label|
      expect(secret_label).to have_content("_")
    end
  end
  
  def player_make_correct_guess
    find(".game-input").find_button("d").click
  end
  
  def expect_correct_guess_visible_in_game_secret
    expect(find(".game-secret .label:first-child")).to have_content("d")
  end
  
  def expect_unguessed_secret_still_obscured
    all(".game-secret .label:not(:first-child)").each do |secret_label|
      expect(secret_label).to have_content("_")
    end
  end
  
  it "allows player to submit a valid guess" do
    visit_game_detail_page
    expect_game_secret_obscured
    
    player_make_correct_guess
    expect_correct_guess_visible_in_game_secret
    expect_unguessed_secret_still_obscured
  end
  
end
