class Connect

  def initialize
    @board = Hash[(1..7).map { |num| [num, Array.new(6)] }]
    @player1 = "\u26aa"
    @player2 = "\u26ab"
  end

  def place_player(column, player, count = 5)
    return @board[column][count] = player if @board[column][count].nil?

    if count.negative?
      puts 'Please try another column, That one is full already!'
      answer = gets.chomp.to_i
      return place_player(answer, player, 5)
    end
    place_player(column, player, count -= 1) unless @board[column][count].nil?
  end

  def victory?(count = 0)
    @board.each do |key, value| 
      value.each do |item| 
        p item
      end
    end
  end
  
  def display_board
    @board
  end
end


bored = Connect.new
bored.victory?

