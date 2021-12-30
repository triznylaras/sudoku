module Sudoku
  class Board
    attr_reader :grid

    def initialize(input = {})
      @grid = input.fetch(:grid, default_grid)
    end

    def default_grid
      Array.new(9) { Array.new(9) { Cell.new(0) } }
    end

    def get_cell(x_ax, y_ax)
      grid[y_ax][x_ax]
    end

    def set_cell(x_ax, y_ax, value)
      grid[y_ax][x_ax].value = value
    end

    def formatted_grid
      grid.each do |row|
        puts row.map(&:value).join(' ')
      end
    end
  end
end
