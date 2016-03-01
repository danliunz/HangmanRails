require "rails_helper"

RSpec.describe MakeGuess, :type => :service do
  let(:secret) { "newzealand" }
  let(:game) { Game.create!(secret: secret, initial_number_of_lives: 6) }
  let(:guess) { "n" }
  subject(:make_guess) { MakeGuess.new(game, guess) }
   
  def win_game
    secret.chars.uniq.each { |letter| MakeGuess.new(game, letter).call }
  end
  
  describe "#call" do
    context "with valid guess " do
      it "succeeds" do
        expect(make_guess.call).to be true
        expect(make_guess.error_message).to be_empty
      end
      
      it "persists the guess into DB" do
        expect(make_guess.call).to be true
        expect(game.guesses.where(letter: "n")).not_to be_empty
      end
    end
    
    context "when game is over" do
      let(:guess) { "x" }
      
      before(:each) { win_game }
      
      it "fails" do
        expect(make_guess.call).to be false
        expect(make_guess.error_message).to match(/game over/)
      end
    end
    
    context "with repeated guess" do
      before(:each) { make_guess.call }
      
      it "fails" do
        expect(make_guess.call).to be false
        expect(make_guess.error_message).to match(/guessed before/)
      end
    end
  end
end
