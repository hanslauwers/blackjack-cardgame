require_relative 'card'
class Deck
  attr_reader :suits, :ranks
  attr_accessor :deck
  
  def initialize(suits, ranks)
    @deck = []
    @ranks = ranks
    @suits = suits
    @deck = @suits.product(@ranks).map { |suit, rank| Card.new(suit, rank) }
  end
  
  def shuffle
    @deck.shuffle!
  end
  
  def deal_card
    @deck.pop
  end
  
  def replace_with(new_deck)
    @suits = []
    @ranks = []
    @deck = new_deck
    
    new_deck.each do |card|
      add_suit_and_rank(card)
    end  
    
    self
  end
  
  private
  
  def add_suit_and_rank(card)
    suit = card.suit
    rank = card.rank
    @suits.push(suit) unless @suits.include?(suit)
    @ranks.push(rank) unless @ranks.include?(rank)
  end
end