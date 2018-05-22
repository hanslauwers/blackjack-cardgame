require_relative 'card'

class Hand
  VALUES = {'2':2, '3':3, '4':4, '5':5, '6':6, '7':7, '8':8, '9':9, '10':10, 'Jack':10, 'Queen':10, 'King':10, 'Ace':1 }
  attr_accessor :dealt_cards
  
  def initialize
    @dealt_cards = []
  end
  
  def add_card(card)
    @dealt_cards.push(card)
  end
  
  def get_value
    card_ranks = dealt_cards.map(&:rank)
    result = card_ranks.reduce(0) { |sum, rank| sum + VALUES[rank.to_sym] }
    
    if (card_ranks.include?('Ace') && result <= 11)
      result += 10
    end
    
    result
  end
  
  def to_s
    report = ""
    dealt_cards.each do |card|
      report += card.to_s + ", " if card.show
    end
    
    if(dealt_cards.first.show == false)
      value = get_value
      first_value = VALUES[dealt_cards.first.rank.to_sym]
      if (dealt_cards.first.rank == 'Ace' && value > 11)
        first_value += 10
      end
      report += "Total value: " + (value - first_value).to_s
    else
      report += "Total value: " + get_value.to_s
    end
  end
end