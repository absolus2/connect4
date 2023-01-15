require_relative 'config'

class Connect
  attr_reader :board, :null, :player1, :player2, :turn

  include Initials

  def initialize
    @null = "\u26d4"
    @board = Hash[(1..7).map { |num| [num, Hash[(1..6).map { |row| [row, @null] }]] }]
    @player1 = "\u26aa"
    @player2 = "\u26ab"
    @turn = 1
    save_config
  end

  def play
    intro
    until game_over
      display_board
      turn
      @turn += 1
    end
  end

  def place_player(column, player, count = 6)
    return @board[column][count] = player if @board[column][count] == @null

    if @board[column].values.none?(@null)
      puts 'Please try another column, That one is full already!'
      answer = gets.chomp.to_i
      return place_player(answer, player, 6)
    end

    place_player(column, player, count -= 1)
  end

  def victory?(player, vic = { v: 0, h: nil, d: nil })
    @board.each do |column, value|
      value.each do |row, values|
        vic[:d] = get_diagonal(column, row)
        values == player ? vic[:v] += 1 : vic[:v] = 0
        vic[:h] = get_horizontal(column, row)
        break if win(vic, player)
      end
      break if win(vic, player)
    end
    win(vic, player)
  end

  def get_horizontal(column, row, horizonal = [@board[column][row]])
    4.times do
      begin
        horizonal.push(@board[column += 1][row])
      rescue NoMethodError
        next
      end
      break if horizonal.length == 4
    end
    horizonal if horizonal.length == 4
  end

  def win(vic, player)
    unless vic[:d].nil?
      return true if vic[:d].values[0].all?(player) || vic[:d].values[1].all?(player)
    end

    unless vic[:h].nil?
      return true if vic[:h].all?(player)
    end
    true if vic[:v] == 4
  end

  def get_diagonal(column, value, count = value, array = { dd: [@board[column][value]], du: [@board[column][value]] })
    4.times do
      begin
        array[:dd].push(@board[column += 1][value += 1])
        array[:du].push(@board[column][count -= 1])
      rescue NoMethodError
        next
      end
      break if array[:du].length == 4
    end
    array if array[:du].length == 4
  end

  def turn
    if @turn.odd?
      played_turn(@player1)
    elsif @turn.even?
      played_turn(@player2)
    end
  end

  def game_over
    if victory?(@player1)
      puts 'Congratz, YOU WON!!!! player1 !!!'
      return true
    end
    if victory?(@player2)
      puts 'Congratz, YOU WON!!!! player2 !!!'
      return true
    end
    false
  end

  private

  def played_turn(player)
    puts "Its your turn to play player #{player}, please Pick a column!"
    column = gets.chomp
    column = letter_error(column)
    place_player(column, player) unless column =~ /^[0-9]{1}$/
  end

  def letter_error(column)
    column.downcase
    save_game if column.include?('s')

    until column =~ /^[0-9]{1}$/
      puts 'Please input a valid number from 1 to 7, letters or symbols not accepted'
      column = gets.chomp
    end
    column.to_i
  end

  def intro
    puts 'Hello, This is connect 4, The rules are just like the basic game.'
    puts 'You align 4 balls of your colour either horizontally, vertically or diagonally if you do so, You win!'
    puts "Player 1 will be #{@player1} and player 2 will be #{@player2}"
    puts 'You can save the game at anytime typing "S" or "Save" onto the console'
    check_load
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

bored.play