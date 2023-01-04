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
        6 .times { game.place_player(1, @player1) }
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
    let(:player1) { game.instance_variable_get(:@player1) }
    let(:victory) { game.victory?(player1) }
    context 'verctical victory' do

      it 'return true for a vertical victory on the first column' do
        4.times { game.place_player(1, player1) }
        expect(victory).to be(true)
      end

      it 'return true for a vertical victory on the last column' do
        4.times { game.place_player(7, player1) }
        expect(victory).to be(true)
      end

      it 'return nil when theres not victory on column 1' do
        3.times { game.place_player(1, player1) }
        expect(victory).to be(false)
      end

      it 'return nil when theres not victory on column 7' do
        3.times { game.place_player(7, player1) }
        expect(victory).to be(false)
      end
    end

    context 'horizontal victory' do

      it 'return true when theres a 4 in a row in the last row' do
        count =  0
        4.times { game.place_player(count += 1, player1) }
        expect(victory).to eq(true)
      end

      it 'return false when theres no horizontal victory' do
        count =  0
        3.times { game.place_player(count += 1, player1) }
        expect(victory).to eq(false)
      end
    end

    context 'diagonal victory' do

      before do
        @board = game.instance_variable_get(:@board)
      end

      it 'returns true when theres a diagonal victory on the first column and first row' do
        @board[1] = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6  =>'⚪' }
        @board[2] = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 =>'⚪', 6  => '⚫' }
        @board[3] = { 1 => 0, 2 => 0, 3 => 0, 4 => '⚪', 5 => '⚫', 6 => '⚫' }
        @board[4] = { 1 => 0, 2 => 0, 3 => '⚪', 4 => '⚫', 5 => '⚫', 6 => '⚫' }
        expect(victory).to eq(true)
      end

      it 'returns false when theres no diagonal victory' do
        expect(victory).to eq(false)
      end
    end

  end

  describe '#vv?' do
    context 'check vertical victory conditions' do
      

      before do
        @player1 = game.instance_variable_get(:@player1)
      end

      it 'when given a hash counts the amount of times a player appears in the column if 4 return true' do
        column = { 1 => 0, 2 => 0, 3 => @player1, 4 => @player1, 5 => @player1, 6 => @player1 }
        victory = game.vv?(@player1, column)
        expect(victory).to eq(true)
      end

      it 'when given a hash return nil if the count is not 4' do
        column = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0 }
        victory = game.vv?(@player1, column)
        expect(victory).to eq(nil)
      end
    end

  end

  describe 'display_board' do
    context 'every turn of the game' do
      it 'puts 6  times board' do
        expect(game).to receive(:puts).exactly(6 ).times
        game.display_board
      end
    end
  end

end

