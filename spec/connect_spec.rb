# frozen_string_literal: true

require_relative '../lib/connect'


describe Connect do
  
  subject(:game) { described_class.new }

  describe '#initialize' do

    context 'When game start' do

      before do
        @board = Hash[(1..7).map { |num| [num, Array.new(6)] }]
        @player1 = game.instance_variable_get(:@player1)
        @player2 = game.instance_variable_get(:@player2)
      end

      it 'should create a board(hash)' do
        board = game.instance_variable_get(:@board)
        expect(board).to eq(@board)
      end

      it 'the board should be of length 7' do
        expect(@board.length).to eq(7)
      end

      it 'the board value should be nil and length of 6' do
        expect(@board[1]).to eq([nil, nil, nil, nil, nil, nil])
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
      end

      it 'when picking column 1 change the last value of the array to the player' do
        expect { game.place_player(1, @player1) }.to change { @board[1].last }.from(nil).to(@player1)
      end

      it 'when picking column 7 change the last value of the array to the player' do
        expect { game.place_player(7, @player1) }.to change { @board[7].last }.from(nil).to(@player1)
      end
    end

    context 'when placing a player in a column with a player already there' do
      before do
        @board = game.instance_variable_get(:@board)
        @player1 = game.instance_variable_get(:@player1)
        game.place_player(7, @player1)
      end

      it 'add the player to the second last position' do
        expect { game.place_player(7, @player1) }.to change { @board[7][5] }.from(nil).to(@player1)
      end

    end
  end
end
