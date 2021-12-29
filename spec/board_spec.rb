require 'spec_helper'

module Sudoku
  describe Board do
    let(:board) { Board.new }

    context '#initialize' do
      it 'initializes the board with a grid' do
        expect { Board.new(grid: 'grid') }.to_not raise_error
      end

      it 'sets the grid with 9 rows by default' do
        expect(board.grid.size).to eq(9)
      end

      it 'create 9 things in each row (column) by default' do
        board.grid.each do |row|
          expect(row.size).to eq(9)
        end
      end
    end

    context '#grid' do
      it 'returns the grid' do
        board = Board.new(grid: 0)
        expect(board.grid).to eq 0
      end
    end

    context '#get_cell' do
      it 'returns the cell based on the (x, y) coordinate' do
        grid = [['', '', ''], ['', '', ''], ['', 'something', '']]
        board = Board.new(grid: grid)
        expect(board.get_cell(1, 2)).to eq 'something'
      end
    end

    context '#set_cell' do
      it 'updates the value of the cell object at a (x, y) coordinate' do
        grid = [['', Cell.new(3), ''], ['', '', ''], ['', '', '']]
        board = Board.new(grid: grid)
        board.set_cell(1, 0, 6)
        expect(board.get_cell(1, 0).value).to eq 6
      end
    end
  end
end
