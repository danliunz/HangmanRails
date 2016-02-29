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
  
  let(:lives) { 6 }
  let(:secret) { "valid" }
  subject(:game) { Game.create(secret: secret, initial_number_of_lives: lives) }
  
  describe "#new" do
    context "with invalid secret" do
      let(:secret) { "MUST BE LOWCASE WORD"}
      
      it "creates invalid instance" do
        expect(game).to be_invalid
      end
    end

    context "with initial_number_of_lives as non-positive integer" do
      let(:lives) { -1 }
      
      it "creates invalid instance" do
        expect(game).to be_invalid
      end
    end
  end
  
  context "after created successfully" do
    let(:secret) { "goblin" }
    
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
  
  context "when guesses are submitted" do
    let(:secret) { "xyz" }
    let(:lives) { 7 }
    let(:guesses) { %w{a b c} }
    before(:each) do
      guesses.each { |guess| MakeGuess.new(game, guess).call }
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
    
    context "when all secrets are guessed" do
      let(:guesses) { %w{a b c z y x} }
      
      it "is won" do
        expect_game_won
      end
    end
  end
end