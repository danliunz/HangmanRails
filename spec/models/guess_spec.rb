require "rails_helper"

RSpec.describe Guess, :type => :model do
  let(:secret) { "wellington" }
  let(:game) { Game.create!(secret: secret, initial_number_of_lives: 6) }
    
  context "when created incorrectly" do
    it "reports missing association with game" do
      guess = Guess.new(letter: "a")
      
      expect(guess).to be_invalid
      expect(guess.errors[:game]).not_to be_empty
    end
    
    it "reports invalid guessed letter" do
      guess = Guess.new(game: game, letter: "1")
      
      expect(guess).to be_invalid
      expect(guess.errors[:letter]).not_to be_empty
    end
  end    
end