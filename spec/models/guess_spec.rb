require "rails_helper"

RSpec.describe Guess, :type => :model do
  context "when created incorrectly" do
    let(:secret) { "wellington" }
    let(:game) do 
      game = Game.new(secret: secret, initial_number_of_lives: 6)
      game.save!
      game
    end
    
    def finish_game
      secret.chars.uniq.each { |letter| MakeGuess.new(game, letter).call }  
    end
    
    it "reports missing association with game" do
      guess = Guess.new(letter: "a")
      expect(guess).to be_invalid
      expect(guess.errors[:game]).not_to be_empty
    end
    
    it "reports invalid guessed letter" do
      guess = MakeGuess.new(game, "1").call
      expect(guess).to be_invalid
      expect(guess.errors[:letter]).not_to be_empty
    end
    
    it "reports repeated guess" do
      guess = MakeGuess.new(game, "f").call
      expect(guess).to be_valid
      
      guess = MakeGuess.new(game, "f").call
      expect(guess.errors[:letter].first).to match(/guessed before/)
    end
    
    it "reports game over" do
      finish_game
      expect(game).to be_over
      
      guess = MakeGuess.new(game, "x").call
      expect(guess.errors[:base].first).to match(/game over/)
    end
  end
  
  context "when created correctly" do
    let(:game) do 
      game = Game.new(secret: "success", initial_number_of_lives: 6)
      game.save!
      game
    end
    
    it "can be saved into DB" do
      guess = MakeGuess.new(game, "s").call
      expect(guess).to be_valid
      expect(game.guesses.count).to eq(1)
      
      guess.reload
      expect(guess).to be_valid
      expect(guess.letter).to eq("s")
    end
  end
end