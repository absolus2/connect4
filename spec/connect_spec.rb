# frozen_string_literal: true

require_relative '../lib/connect'

describe Connect do
  subject(:game) { described_class.new }

  describe '#initialize' do
    context 'When game start' do
      before do
        @board = game.instance_variable_get(:@board)
        @null = game.instance_variable_get(:@null)
        @player1 = game.instance_variable_get(:@player1)
        @player2 = game.instance_variable_get(:@player2)
      end

      it 'should create a board (hash of hashes)' do
        expect(@board).to be_a Hash
      end

      it 'the board should be of length 7' do
        result = @board.length
        expect(result).to eq(7)
      end

      it 'the board rows should be of lenght 6 ' do
        row = @board[1].length
        expect(row).to eq(6 )
      end

      it 'the board row value should be null' do
        null = @board[1][1]
        expect(null).to eq("\u26d4")
      end

      it 'should initialize two players with a unicode value, a black and white ball' do
        expect(@player1).to eq("\u26aa")
        expect(@player2).to eq("\u26ab")
      end

    end
  end

  describe '#place_player' do
    context 'when placing a player in an empty column' do

      before do
        @board = game.instance_variable_get(:@board)
        @player1 = game.instance_variable_get(:@player1)
        @null = game.instance_variable_get(:@null)
      end

      it 'when picking column 1 change the last value of the array to the player' do
        expect { game.place_player(1, @player1) }.to change { @board.values[0].values.last }.from(@null).to(@player1)
      end

      it 'when picking column 7 change the last value of the array to the player' do
        expect { game.place_player(7, @player1) }.to change { @board.values[6 ].values.last }.from(@null).to(@player1)
      end
    end

    context 'when placing a player in a column with a player already there' do
      before do
        @board = game.instance_variable_get(:@board)
        @player1 = game.instance_variable_get(:@player1)
        @null = game.instance_variable_get(:@null)
        game.place_player(7, @player1)
      end

      it 'add the player to the second last position' do
        expect { game.place_player(7, @player1) }.to change { @board.values[6 ].values[-2] }.from(@null).to(@player1)
      end

      it 'keeps the same length of 6  for the row' do
        row = @board[1].length
        expect(row).to eq(6 )
      end
    end

    context 'when a column is full' do
      before do
        @board = game.instance_variable_get(:@board)
        @player1 = game.instance_variable_get(:@player1)
        6.times { game.place_player(1, @player1) }
      end

      it 'returns a message about the column being full' do
        allow(game).to receive(:gets).and_return('2')
        expect(game).to receive(:puts).with('Please try another column, That one is full already!').once
        game.place_player(1, @player1)
      end

      it 'returns a message about the column being full twice' do
        allow(game).to receive(:gets).and_return('1', '2')
        expect(game).to receive(:puts).with('Please try another column, That one is full already!').twice
        game.place_player(1, @player1)
      end
    end
  end

  describe '#victory?' do

    let(:board) { game.instance_variable_get(:@board) }
    let(:player) { game.instance_variable_get(:@player1) }
    let(:playerb) { game.instance_variable_get(:@player2) }

    context 'vertical victory' do

      it 'true for vertical victory on first column' do
        4.times { game.place_player(1, player) }
        victory = game.victory?(player)
        expect(victory).to be(true)
      end

      it 'nil when theres no vertical victory on first column ' do
        3.times { game.place_player(1, player) }
        no_vic = game.victory?(player)
        expect(no_vic).to be(nil)
      end
    end

    context 'horizontal victory' do
      it 'true for horizontal victory on the last row' do
        count = 0
        4.times { game.place_player(count += 1, player) }
        victory = game.victory?(player)
        expect(victory).to be(true)
      end

      it 'nil when theres is no horizontal victory' do
        count = 0
        3.times { game.place_player(count += 1, player) }
        no_vic = game.victory?(player)
        expect(no_vic).to be(nil)
      end
    end

    context 'diagonal victory' do
      it 'true when there is a upppper diagonal victory' do
        game.instance_variable_set(:@board, { 1 => { 1 => '⛔', 2 => '⛔', 3 => '⛔', 4 => '⛔', 5 => '⛔', 6 => '⚪'}, 2 => { 1 => '⛔', 2 => '⛔', 3 => '⛔', 4 => '⛔', 5 => '⚪', 6 => '⚫'}, 3 => { 1 => '⛔', 2 => '⛔', 3 => '⛔', 4 => '⚪', 5 => '⚫', 6 => '⚫'}, 4 => { 1 => '⛔', 2 => '⛔', 3 => '⚪', 4 => '⚫', 5 => '⚫', 6 => '⚫'}, 5 => { 1 => '⛔', 2 => '⛔', 3 => '⛔', 4 => '⛔', 5 => '⛔', 6 => '⛔'}, 6 => { 1 => '⛔', 2 => '⛔', 3 => '⛔', 4 => '⛔', 5 => '⛔', 6 => '⛔'}, 7 => { 1 => '⛔', 2 => '⛔', 3 => '⛔', 4 => '⛔', 5 => '⛔', 6 => '⛔'} })
        victory = game.victory?(player)
        expect(victory).to be(true)
      end

      it 'true when there is a diagonal down victory' do
        game.instance_variable_set(:@board, { 1 => { 1 => '⛔', 2 => '⛔', 3 => '⚪', 4 => '⚫', 5 => '⚫', 6 => '⚫'}, 2 => { 1 => '⛔', 2 => '⛔', 3 => '⛔', 4 => '⚪', 5 => '⚫', 6 => '⚫'}, 3 => { 1 => '⛔', 2 => '⛔', 3 => '⛔', 4 => '⛔', 5 => '⚪', 6 => '⚫'}, 4 => { 1 => '⛔', 2 => '⛔', 3 => '⛔', 4 => '⛔', 5 => '⛔', 6 => '⚪'}, 5 => { 1 => '⛔', 2 => '⛔', 3 => '⛔', 4 => '⛔', 5 => '⛔', 6 => '⛔'}, 6 => { 1 => '⛔', 2 => '⛔', 3 => '⛔', 4 => '⛔', 5 => '⛔', 6 => '⛔'}, 7 => { 1 => '⛔', 2 => '⛔', 3 => '⛔', 4 => '⛔', 5 => '⛔', 6 => '⛔'} })
        victory = game.victory?(player)
        expect(victory).to be(true)
      end

      it 'nil when there is no diagonal victory' do
        no_vic = game.victory?(player)
        expect(no_vic).to be(nil)
      end
    end
    
  end

  describe '#game_over' do
    let(:player1) { game.instance_variable_get(:@player1) }
    let(:player2) { game.instance_variable_get(:@player2) }
    context 'when a player won the game' do

      it 'puts a message and congratz' do
        4.times { game.place_player(1, player1) }
        expect(game).to receive(:puts).with('Congratz, YOU WON!!!! player1 !!!').once
        game.game_over
      end

      it 'puts a message when player2 wins' do
        4.times { game.place_player(1, player2) }
        expect(game).to receive(:puts).with('Congratz, YOU WON!!!! player2 !!!').once
        game.game_over
      end

      it 'returns false when the game isnt over' do
        over = game.game_over
        expect(over).to be(false)
      end
    end
  end
  
  describe '#turn' do
    context 'when the turn even or odd' do

      let(:player1) { game.instance_variable_get(:@player1) }
      let(:player2) { game.instance_variable_get(:@player2) }
      before do
        allow(game).to receive(:gets).and_return('2')
      end

      it 'when the turn is odd, player1 plays their turn' do
        expect(game).to receive(:puts).with("Its your turn to play player #{player1}, please Pick a column!").once
        game.turn
      end

      it 'when the turn is even, player2 plays their turn' do
        game.instance_variable_set(:@turn, 2)
        expect(game).to receive(:puts).with("Its your turn to play player #{player2}, please Pick a column!").once
        game.turn
      end
    end
  end

  describe '#save_config' do
    context 'When the game initialize' do

      before do
        allow(Dir).to receive(:exist?).and_return(false)
        allow(Dir).to receive(:mkdir)
      end

      it 'checkto see if there is a directory already' do
        expect(Dir).to receive(:exist?).with('config').twice
        game.save_config
      end

      it 'Creates the directory if there is not one already' do
        expect(Dir).to receive(:mkdir).with('config').twice
        game.save_config
      end
    end
  end

  describe 'save_game' do
    context 'when saving the game' do
      before do
        allow(Dir).to receive(:exist?).and_return(false)
        allow(Dir).to receive(:mkdir)
        allow(File).to receive(:open)
      end

      it 'Create the dir if it doesnt exist' do
        expect(Dir).to receive(:mkdir).with('Saves').once
        game.save_game
      end

      it 'Create the file' do
        expect(File).to receive(:open).twice
        game.save_game
      end
    end
  end

  describe 'load_game' do
    context 'when initializing the game' do
      before do
        allow(Dir).to receive(:exist?).and_return(true)
        allow(Dir).to receive(:entries).and_return(%w[saved_game1 saved_game2])
      end

      it 'return a list of all files inside the save folder.' do
        list = game.load_game
        expect(list).to eq(%w[saved_game1 saved_game2])
      end

      it 'loads the file the user wants' do

      end
      
    end

  end

  describe 'check_load' do
    context 'When the answer is y/yes' do
      before do
        allow(Dir).to receive(:entries).and_return(%w[saved_game1 saved_game2 saved_game3])
        allow(game).to receive(:gets).and_return('y')
      end

      it 'output the list of files to load the game' do
        expect(game).to receive(:puts).twice
        game.check_load
      end
    end
  end

end

