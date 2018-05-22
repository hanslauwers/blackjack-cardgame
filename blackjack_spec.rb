require_relative 'blackjack'

RSpec.describe BlackJack do
  
  SUITS = ['Spades', 'Hearts', 'Diamonds', 'Clubs']
  RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
  
  before do
    @blackjack = BlackJack.new(SUITS, RANKS)
  end
  
  describe "instance methods" do
    subject { @blackjack }
    
    it { is_expected.to respond_to(:player_hand) }
    it { is_expected.to respond_to(:dealer_hand) }
    it { is_expected.to respond_to(:playing) }
    it { is_expected.to respond_to(:current_gamer) }
    it { is_expected.to respond_to(:deck) }
    it { is_expected.to respond_to(:deal) }
    it { is_expected.to respond_to(:hit) }
    it { is_expected.to respond_to(:stand) }
    it { is_expected.to respond_to(:show_hands) }
    it { is_expected.to respond_to(:set_results) }
  end
  
  describe "dealing cards" do
    before do
      @blackjack.deal
      @dealer_cards = @blackjack.dealer_hand.dealt_cards
      @player_cards = @blackjack.player_hand.dealt_cards
    end
    
    it "returns two cards for dealer and player" do
      expect(@dealer_cards.count).to eq(2)
      expect(@player_cards.count).to eq(2)
    end
    
    it "does not display the first card for the dealer" do
      expect(@dealer_cards.first.show).to be_falsey
    end
    
    it "ends the player's turn if he/she has a blackjack" do
      card1 = Card.new("Clubs", "10")
      card2 = Card.new("Hearts", "Ace")
      card3 = Card.new("Diamonds", "3")
      
      card4 = Card.new("Diamonds", "10")
      card5 = Card.new("Diamonds", "King")
      card6 = Card.new("Clubs", "Queen")
      
      @blackjack = BlackJack.new(SUITS, RANKS)
      
      new_deck = [card4, card5, card2, card3, card1, card6 ]
      @blackjack.deck.replace_with(new_deck)
      @blackjack.deal
      
      expect(@blackjack.current_gamer).to eq('Dealer')
    end
  end
  
  describe "hitting a hand" do
    
    before do
      @blackjack.deal
      @player_cards = @blackjack.player_hand.dealt_cards
      @dealer_cards = @blackjack.dealer_hand.dealt_cards
    end
    
    it "can hit if 'playing' is set to true" do
      expect(@blackjack.playing).to be_truthy
    end
    
    it "returns two cards for dealer but after 'hit' player will have 3 cards" do
      @blackjack.hit
      expect(@dealer_cards.count).to eq(2)
      expect(@player_cards.count).to eq(3)
    end
    
    it "correctly determines if player is busted" do
      card1 = Card.new("Clubs", "10")
      card2 = Card.new("Hearts", "10")
      card3 = Card.new("Diamonds", "2")
      
      card4 = Card.new("Diamonds", "10")
      card5 = Card.new("Spades", "10")
      card6 = Card.new("Clubs", "Queen")
      
      @blackjack = BlackJack.new(SUITS, RANKS)
      
      new_deck = [card6, card3, card2, card5, card1, card4]
      @blackjack.deck.replace_with(new_deck)
      @blackjack.deal
      @blackjack.hit
      
      expect(@blackjack.result).to eq("Player busted!")
      expect(@blackjack.playing).to be_falsey
    end
    
    it "correctly determines if dealer is busted" do
      card1 = Card.new("Clubs", "10")
      card2 = Card.new("Hearts", "10")
      card3 = Card.new("Diamonds", "Ace")
      
      card4 = Card.new("Diamonds", "10")
      card5 = Card.new("Spades", "10")
      card6 = Card.new("Clubs", "Queen")
      
      @blackjack = BlackJack.new(SUITS, RANKS)
      
      new_deck = [card6, card3, card2, card5, card1, card4]
      @blackjack.deck.replace_with(new_deck)
      @blackjack.deal
      @blackjack.hit
      
      @blackjack.current_gamer = 'Dealer'
      @blackjack.hit
      
      expect(@blackjack.result).to eq("Dealer busted!")
      expect(@blackjack.playing).to be_falsey
    end
  end
  
  describe "standing" do
    
    before do
      @blackjack = BlackJack.new(SUITS, RANKS)
      # @blackjack.deal
      # @player_cards = @blackjack.player_hand.dealt_cards
      # @dealer_cards = @blackjack.dealer_hand.dealt_cards
    end
    
    it "should switch to dealer when player stands" do
      card1 = Card.new("Clubs", "10")
      card2 = Card.new("Hearts", "10")
      card3 = Card.new("Diamonds", "Ace")
      
      card4 = Card.new("Diamonds", "10")
      card5 = Card.new("Spades", "3")
      card6 = Card.new("Clubs", "Queen")
      
      new_deck = [card6, card3, card5, card2, card4, card1]
      @blackjack.deck.replace_with(new_deck)
      @blackjack.deal
      @blackjack.hit
      @blackjack.stand
      
      expect(@blackjack.current_gamer).to eq("Dealer")
    end
    
    it "dealer automatically hits if value of hand is less than 17 and first card faces up" do
      card1 = Card.new("Clubs", "10")
      card2 = Card.new("Hearts", "10")
      card3 = Card.new("Diamonds", "Ace")
      
      card4 = Card.new("Diamonds", "10")
      card5 = Card.new("Spades", "3")
      card6 = Card.new("Clubs", "Queen")
      
      new_deck = [card6, card3, card2, card5, card1, card4]
      @blackjack.deck.replace_with(new_deck)
      @blackjack.deal
      expect(@blackjack.dealer_hand.get_value).to eq(13)
      @blackjack.hit
      @blackjack.stand
      
      expect(@blackjack.dealer_hand.get_value).to eq(23)
      expect(@blackjack.dealer_hand.dealt_cards.first.show).to be_truthy
    end
  end
  
  describe "showing hands" do
    
    before do
      @blackjack.deal
    end
    
    it "should display the gamer's hand" do
      expect(@blackjack.show_hands).to match(/Player's hand/)
      expect(@blackjack.show_hands).to match(/Total value:/)
      expect(@blackjack.show_hands).to match(/Dealer's hand/)
      expect(@blackjack.show_hands).to match(/Total value:/)
    end
  end
  
  describe "settings results" do
    
    before do
      @blackjack = BlackJack.new(SUITS, RANKS)
    end
    
    it "sets the correct result when player busts" do
      card1 = Card.new("Clubs", "10")
      card2 = Card.new("Hearts", "10")
      card3 = Card.new("Diamonds", "2")
      
      card4 = Card.new("Diamonds", "10")
      card5 = Card.new("Spades", "10")
      card6 = Card.new("Clubs", "Queen")
      
      new_deck = [card6, card3, card2, card5, card1, card4]
      @blackjack.deck.replace_with(new_deck)
      @blackjack.deal
      @blackjack.hit
      expect(@blackjack.set_results).to eq("Player busted!")
    end
    
    it "sets the correct result when dealer busts" do
      card1 = Card.new("Clubs", "10")
      card2 = Card.new("Hearts", "10")
      card3 = Card.new("Diamonds", "2")
      
      card4 = Card.new("Diamonds", "10")
      card5 = Card.new("Spades", "4")
      card6 = Card.new("Clubs", "Queen")
      
      new_deck = [card6, card3, card2, card5, card1, card4]
      @blackjack.deck.replace_with(new_deck)
      @blackjack.deal
      @blackjack.stand
      @blackjack.hit
      expect(@blackjack.set_results).to eq("Dealer busted!")
    end
    
    it "sets the correct result when there is a tie" do
      card1 = Card.new("Clubs", "10")
      card2 = Card.new("Hearts", "10")
      card3 = Card.new("Diamonds", "Ace")
      
      card4 = Card.new("Diamonds", "10")
      card5 = Card.new("Spades", "10")
      card6 = Card.new("Clubs", "Ace")
      
      new_deck = [card6, card3, card2, card5, card1, card4]
      @blackjack.deck.replace_with(new_deck)
      @blackjack.deal
      @blackjack.hit
      @blackjack.stand
      @blackjack.hit
      expect(@blackjack.set_results).to eq("It's a tie")
    end
    
    it "sets the correct result when player wins" do
      card1 = Card.new("Clubs", "10")
      card2 = Card.new("Hearts", "10")
      card3 = Card.new("Diamonds", "Ace")
      
      card4 = Card.new("Diamonds", "10")
      card5 = Card.new("Spades", "9")
      card6 = Card.new("Clubs", "Ace")
      
      new_deck = [card6, card3, card2, card5, card1, card4]
      @blackjack.deck.replace_with(new_deck)
      @blackjack.deal
      @blackjack.hit
      @blackjack.stand
      @blackjack.hit
      expect(@blackjack.set_results).to eq("Player won!")
    end
    
    it "sets the correct result when dealer wins" do
      card1 = Card.new("Clubs", "10")
      card2 = Card.new("Hearts", "9")
      card3 = Card.new("Diamonds", "Ace")
      
      card4 = Card.new("Diamonds", "10")
      card5 = Card.new("Spades", "10")
      card6 = Card.new("Clubs", "Ace")
      
      new_deck = [card6, card3, card2, card5, card1, card4]
      @blackjack.deck.replace_with(new_deck)
      @blackjack.deal
      @blackjack.hit
      @blackjack.stand
      @blackjack.hit
      expect(@blackjack.set_results).to eq("Dealer won!")
    end
    
  end
  
end