class Connect

  def initialize
    @board = Hash[(1..7).map { |num| [num, Array.new(6) ] }]
    @player1 = "\u26aa"
    @player2 = "\u26ab"
  end

  def display_board
    @board[1].last
  end
end


bored = Connect.new
p bored.display_board