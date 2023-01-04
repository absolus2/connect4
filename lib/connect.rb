class Connect

  def initialize
    @null = "\u26d4"
    @board = Hash[(1..7).map { |num| [num, Hash[(1..6).map { |row| [row, @null] }]] }]
    @player1 = "\u26aa"
    @player2 = "\u26ab"
  end

  def place_player(column, player, count = 6)
    return @board[column][count] = player if @board[column][count] == @null

    if @board[column].values.all? { |item| item == player }
      puts 'Please try another column, That one is full already!'
      answer = gets.chomp.to_i
      return place_player(answer, player, 6)
    end

    place_player(column, player, count -= 1)
  end

  def testing(player, vic = { v: 0, h: Hash[(1..6).map { |num| [num, 0] }], d: nil })
    @board.each do |column, value|
      value.each do |row, values|
        vic[:d] = get_diagonal(column, row)
        values == player ? vic[:v] += 1 : vic[:v] = 0
        vic[:h][row] += 1 if values == player
        break if win(vic, player)
      end
      break if win(vic, player)
    end
    win(vic, player)
  end

  def win(vic, player)
    return true if vic[:d].values.each.all? { |item| item == player }
    return true if vic[:v] == 4
    return true if vic[:h].values.any?(4)
  end

  def get_diagonal(column, value, array = { dd: [@board[column][value]], du: [@board[column][value]] })
    count = value
    4.times do
      begin
        array[:dd].push(@board[column += 1][value += 1])
        array[:du].push(@board[column][count -= 1])
      rescue NoMethodError
        next
      end
      break if array[:du].length == 4
    end
    array
  end

  def display_board(row = 1, flag: false)
    until flag
      puts "#{@board[1][row]}#{@board[2][row]}#{@board[3][row]}#{@board[4][row]}#{@board[5][row]}#{@board[6][row]}#{@board[7][row]}"
      row += 1
      flag = true if row == 7
    end
  end

end

bored = Connect.new


bored.place_player(4, "\u26ab")
bored.testing("\u26ab")
bored.display_board

