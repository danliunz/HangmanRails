require "rails_helper"

RSpec.describe Game, :type => :model do
  def expect_game_not_over
    expect(game).not_to be_over
    expect(game).not_to be_won
    expect(game).not_to be_lost
  end
  
  def expect_game_won
    expect(game).to be_over
    expect(game).to be_won
    expect(game).not_to be_lost
  end
  
  def expect_game_lost
    expect(game).to be_over
    expect(game).not_to be_won
    expect(game).to be_lost
  end
  
  describe "#new" do
    it "fails with invalid secret" do
      game = Game.new(secret: "NOT LOWCASE WORD", initial_num_of_lives: 6)
      expect(game).not_to be_valid
    end
    
    it "fails if initial_number_of_lives are not positive integer" do
      game = Game.new(secret: "valid", initial_num_of_lives: -1)
      expect(game).not_to be_valid
    end
  end
  
  describe "#guesses" do
    let(:secret) { ("a" .. "z").to_a.join }
    subject(:game) { Game.create!(secret: secret, initial_num_of_lives: 6) }
    
    it "returns letters ordered by guessing time ascendingly" do
      ("a" .. "z").each { |guess| SubmitGuess.call(game, guess) }
      
      game.guesses.reload
      
      expect(game.guesses.map { |guess| guess.letter })
        .to eq(("a" .. "z").to_a)
    end
  end
  
  context "after created successfully" do
    let(:secret) { "goblin" }
    let(:lives) { 6 }
    subject(:game) do
      Game.new(secret: secret, initial_num_of_lives: lives)
    end
    
    it "has 0 missed guesses" do
      expect(game.missed_guesses).to be_empty
      expect_game_not_over
    end
    
    it "has 0 guesses" do
      expect(game.guesses).to be_empty
    end
    
    it "is not over" do
      expect_game_not_over
    end
  end
  
  context "when submitted guesses" do
    let(:guesses) { %w{a b c} }
    let(:game) { Game.create!(secret: "xyz", initial_num_of_lives: 7) }
    before(:each) do
      guesses.each { |guess| SubmitGuess.call(game, guess) }
    end
    
    it "records all guesses" do
      guesses.each do |guess| 
        expect(game.guessed?(guess)).to be true
      end
    end
  
    context "with too many misses" do
      let(:guesses) { ("a" .. "g").to_a }
      
      it "records all missed guesses" do
        expect(game.missed_guesses.map(&:letter)).to eq(guesses)
      end
      
      it "is lost" do
        expect_game_lost
      end
    end
    
    context "matching all secret letters" do
      let(:guesses) { %w{a b c z y x} }
      
      it "is won" do
        expect_game_won
      end
    end
  end
end