class Deck
  attr_accessor :cards

  SUITES = %w(Hearts Tiles Clovers Pikes)
  CARDS = %w(Ace Two Three Four Five Six Seven Eight Nine Ten Knave Queen King)

  def initialize
    shuffle_deck
  end

  def draw
    card = cards.sample
    cards.reject!{ |c| c == card }
    card
  end

  private

  def shuffle_deck
    self.cards = []
    SUITES.each do |suite|
      CARDS.each_with_index do |name, index|
        cards << Card.new(suite, name, index)
      end
    end
  end

  class Card
    attr_accessor :index, :name, :suite
    def initialize(suite, name, index)
      @suite = suite
      @name = name
      @index = index
    end

    def value
      return 11 if index == 0
      return 10 if index >= 9
      index+1
    end

    def ace?
      index == 0
    end

    def ten?
      value == 10
    end
  end
end

class ChanceOfAce
  N = 10000
  def sample
    deck = Deck.new

    cards_drawed = []
    N.times do
      cards_drawed << deck.draw
    end

    aced_picked = cards_drawed.select(&:ace?)
    probability = aced_picked.length.to_f / N.to_f
    puts "Aced cards drawed: #{aced_picked.count}"
    puts "Probability: #{probability} vs #{4/52.to_f}"
  end
end

class BlackJackSecondCard
  N = 100000
  def sample
    deck = Deck.new
    cards_drawed = []
    N.times { cards_drawed << deck.draw }
    tens_drawed = cards_drawed.select(&:ten?)
    probability = tens_drawed.length.to_f / N.to_f
    puts "Tens drawed: #{tens_drawed.length}"
    puts "Probability: #{probability} vs #{16/51.to_f}"
  end
end

class GettingBjWithTwoCards
  N = 100000
  def sample
    times_hit_bj = 0
    cards = []
    N.times do
      deck = Deck.new
      cards = []
      2.times { cards << deck.draw }
      hand_value = cards.map(&:value).reduce(:+)
      if hand_value == 21
        times_hit_bj += 1
      end
    end
    probability = times_hit_bj.to_f / N.to_f

    puts "Times getting blackjack with 2 cards: #{times_hit_bj}"
    puts "Probability: #{probability} vs ??"
  end
end

class BustingWithThreeCards
  N = 100000
  def sample
    times_busted = 0
    N.times do
      cards = []
      deck = Deck.new
      3.times { cards << deck.draw }
      hand_value = cards.map(&:value).reduce(:+)
      times_busted += 1 if hand_value > 21
    end

    puts "Times busted with 3 cards: #{times_busted}"
    probability = times_busted.to_f / N.to_f
    puts "Probability: #{probability}"
  end
end

#N = 100000
#start_values = {}
#busted_values = {}
#N.times do
#  deck = Deck.new
#  hand = []
#  2.times { hand << deck.draw }
#  start_value = hand.map(&:value).reduce(:+)
#  start_values[start_value] ||= 0
#  start_values[start_value] += 1
#
#  hand << deck.draw
#  new_hand_vaule = hand.map(&:value).reduce(:+)
#  if new_hand_vaule > 21
#    busted_values[start_value] ||= 0
#    busted_values[start_value] += 1
#  end
#end
#
#probability = busted_values.sort.map do |k, v|
#  times_started = start_values[k]
#  times_busted = v
#  { k => times_busted.to_f / times_started }
#end
#puts probability

#N = 100000
#times_busted = 0
#total_cards_drawed = 0
#N.times do
#  deck = Deck.new
#  cards = []
#  hand_value = 0
#  while true
#    cards << deck.draw
#    hand_value = cards.map(&:value).reduce(:+)
#    total_cards_drawed += 1
#    break if hand_value > 14
#  end
#  times_busted += 1 if hand_value > 21
#end

class BlackJack
  attr_accessor :deck, :dealer_hand, :player_hand, :game_status

  def initialize
    @deck = Deck.new
    @dealer_hand = []
    @player_hand = []
    game_status = "ongoing"
  end

  def run_game
    dealer_hand << deck.draw

    player_run
    dealer_run
    if player_value > 21
      game_status = "dealer_won"
    elsif dealer_value < 22 && dealer_value > player_value
      game_status = "dealer_won"
    elsif dealer_value == player_value
      game_status = "draw"
    else
      game_status = "player_won"
    end
    game_status
  end

  def player_value
    player_hand.map(&:value).reduce(:+)
  end

  def dealer_value
    dealer_hand.map(&:value).reduce(:+)
  end

  def dealer_run
    while true
      dealer_hand << deck.draw
      break if dealer_value >= 17
    end
  end

  def player_run
    while true
      player_hand << deck.draw
      break if player_value > 14
    end
  end
end

N = 100000
statuses = {}
N.times do
  game = BlackJack.new
  status = game.run_game

  statuses[status] ||= 0
  statuses[status] += 1
end
puts statuses
