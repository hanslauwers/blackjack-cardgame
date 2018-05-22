require_relative 'deck'

SUITS = ['Spades', 'Hearts', 'Diamonds', 'Clubs']
RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']

@deck = Deck.new(SUITS, RANKS)
puts "Last card pre-shuffle: #{@deck.deck.last}"

@deck.shuffle

puts "Last card: #{@deck.deck.last}"
dealt_card = @deck.deal_card
puts "Dealt card: #{dealt_card}"
puts "Last card: #{@deck.deck.last}"

@new_deck = [Card.new('Spades', '7'), Card.new('Clubs', 'Queen'), Card.new('Spades', '5'), Card.new('Hearts', '5')]
@deck.replace_with(@new_deck)
puts "New deck:"

@deck.deck.each { |card| puts card }