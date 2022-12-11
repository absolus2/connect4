class Connect

  def initialize
    @board = Hash[(1..7).map { |num| [num, Array.new(6) ] }]
    @player1 = "\u26aa"
    @player2 = "\u26ab"
  end

  def place_player(column, player, count = 6)
    return @board[column][count] = player if @board[column][count].nil?

    place_player(column, player, count -= 1) unless @board[column][count].nil?
  end
  
  #? @board[column][count] = player : place_player(column, player, -1)
  def display_board
    @board
  end
end

bored = Connect.new

