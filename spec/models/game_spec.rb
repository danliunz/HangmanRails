require "rails_helper"

RSpec.describe Game, :type => :model do
  def expect_game_not_over
    expect(game.over?).to be false
    expect(game.won?).to be false
    expect(game.lost?).to be false
  end
  
  context "when created incorrectly" do
    it "reports invalid secret" do
      game = Game.new(secret: "Not a lower case word", max_misses: 6)
      expect(game).not_to be_valid
      expect(game.errors[:secret]).not_to be_empty
    end
    
    it "reports invalid max_misses" do
      game = Game.new(secret: "valid", max_misses: -1)
      expect(game).not_to be_valid
      expect(game.errors[:max_misses]).not_to be_empty
    end
  end
  
  context "when created correctly" do
    let(:secret) { "goblin" }
    let(:max_misses) { 6 }
    subject(:game) { Game.new(secret: secret, max_misses: max_misses) }
    
    it "has correct state" do
      expect(game.secret).to eq(secret)
      expect(game.guesses).to be_empty
      expect(game.missed_guesses).to be_empty
      expect_game_not_over
    end
    
    it "can be persisted" do
      game.save!
      game.reload
      
      expect(game.secret).to eq(secret)
      expect(game.max_misses).to eq(max_misses)
      expect_game_not_over
    end
  end
  
  context "with submitted guesses" do
    let(:secret) { "xyz" }
    let(:wrong_guesses) { ("a" .. "e").to_a }
    subject(:game) do 
      game = Game.new(secret: secret, max_misses: 6)
      game.save!
      
      wrong_guesses.each do |letter|
        game.guesses.create!(letter: letter)
      end
      
      game
    end
    
    it "has correct state" do
      game.reload
      
      expect(game.guesses.count).to eq(wrong_guesses.size)
      
      wrong_guesses.each do |letter| 
        expect(game.guessed?(letter)).to be true
      end
      
      expect(game.missed_guesses.map(&:letter)).to eq(wrong_guesses)
      
      expect(game).not_to be_over
      expect(game).not_to be_won
      expect(game).not_to be_lost
    end
    
    it "has guesses ordered by submission time ascendingly" do
      game.reload
      
      game.guesses.each_with_index do |guess, index|
        expect(guess.letter).to eq(wrong_guesses[index])
      end
    end
  end
end