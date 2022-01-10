require 'pry-byebug'
require_relative 'display'

module Sudoku
  class SudokuGen
    include Display

    attr_reader :grid, :hints

    def initialize(grid_string = '')
      puts display_rules
      puts display_new_game

      new_puzzle(grid_string)
    end

    def new_puzzle(grid_string)
      # Either take a pre-created puzzle, or create a new one programmatically
      if grid_string != ''
        @grid = grid_string.split('').map(&:to_i)

        raise StandardError unless valid?
      else
        generate until valid?

        new_generate
      end
    end

    def new_generate
      until (obviouses.length <= 5) && (hints <= 40)
        # Assign a random cell to 0, as well as its opposite (to keep the puzzle symmetrical)
        copy = dup

        known = (0...81).to_a - unknowns
        cell = known.sample

        copy.getgrid[cell] = 0
        copy.getgrid[opposite_of(cell)] = 0

        # Only implement the changes if the puzzle is still solvable
        @grid = copy.getgrid if copy.solvable?
      end
    end

    def solvable?
      # First make sure there are >= 17 clues (minimum possible for a sudoku)
      return false if hints < 17

      # Check if the puzzle is able to be solved, and that only one solution is possible
      copy = dup
      copy.solve!

      copy.solved?
    end

    def solved?
      !@grid.include?(0) && valid?
    end

    def solve!
      unchanged = false
      imin = nil
      pmin = []
      min = 10

      until unchanged
        # Loop through grid looking for cells with only one option, then fill that option in.
        # Repeat loop over entire grid until no cells with only one possible answer remain
        unchanged = true

        unknowns.each do |i|
          possible = possible(row_of(i), col_of(i))

          if possible.length == 1
            self[row_of(i), col_of(i)] = possible[0]
            unchanged = false
          elsif unchanged && (possible.length < min)
            imin = i
            pmin = possible
            min = pmin.length
          end
        end
      end

      return unless solved?

      # If solution remains unsolved, then go through the cell with the smallest number of options
      # For each of those options, attempt to solve the puzzle with that option filled in

      @solutions = []

      recheck_solution(pmin, imin)

      # Check if every option yielded the same potential solution
      return unless !@solutions.empty? && @solutions.uniq.length == 1

      # If so, set self's grid to that solution
      @grid = @solutions[0]
    end

    def recheck_solution(pmin, imin)
      pmin.each do |guess|
        new_copy = dup
        new_copy[row_of(imin), col_of(imin)] = guess

        new_copy.solve!

        next unless new_copy.solved?

        # Cache every potential solutions
        @solutions.push(new_copy.getgrid)

        if @solutions.uniq.length > 1
          # Check if there are differing solutions so far
          return false
        end
      end
    end

    def dup
      copy = super
      @grid = @grid.dup
      copy
    end

    def [](row, col)
      @grid[row * 9 + col]
    end

    def []=(row, col, newval)
      @grid[row * 9 + col] = newval
    end

    def to_s
      @grid.join('')
    end

    def getgrid
      @grid
    end

    private

    def generate
      # Generate a puzzle by randomly choosing numbers from every cell's possible numbers
      # Factor in the previously chosen numbers as well
      @grid = [0] * 81

      0.upto 8 do |row|
        0.upto 8 do |col|
          @grid[row * 9 + col] = possible(row, col).sample
        end
      end
    end

    def possible(row, col)
      # Return every possible number for that row and cell
      [1, 2, 3, 4, 5, 6, 7, 8, 9] - (rowdigits(row) + coldigits(col) + boxdigits(box_of(row, col)))
    end

    def unknowns
      # Return array of the indices of unfilled cells
      @grid.each_index.select { |i| @grid[i].zero? }
    end

    def obviouses
      # Return array of every index where only one solution is possible
      unknowns.select { |i| possible(row_of(i), col_of(i)).length == 1 }
    end

    def valid?
      return false unless @grid

      return false unless @grid.length == 81

      @grid.each do |val|
        return false unless val

        return false if val.negative? || val > 9
      end

      !duplicates?
    end

    def duplicates?
      0.upto(8) do |i|
        return true if rowdigits(i).uniq.length != rowdigits(i).length
        return true if coldigits(i).uniq.length != coldigits(i).length
        return true if boxdigits(i).uniq.length != boxdigits(i).length
      end

      false
    end

    def opposite_of(cell)
      row = 8 - row_of(cell)
      col = 8 - col_of(cell)

      row * 9 + col
    end

    def hints
      @grid.count do |h|
        h != 0
      end
    end

    def box_of(row, col)
      # Return the box which contains a certain cell
      indices = [0, 0, 0, 1, 1, 1, 2, 2, 2] * 3 +
                [3, 3, 3, 4, 4, 4, 5, 5, 5] * 3 +
                [6, 6, 6, 7, 7, 7, 8, 8, 8] * 3

      indices[row * 9 + col]
    end

    def row_of(index)
      indices = [0] * 9 + [1] * 9 + [2] * 9 + [3] * 9 + [4] * 9 + [5] * 9 + [6] * 9 + [7] * 9 + [8] * 9

      indices[index]
    end

    def col_of(index)
      indices = [0, 1, 2, 3, 4, 5, 6, 7, 8] * 9

      indices[index]
    end

    def rowdigits(row)
      @grid[row * 9, 9] - [0]
    end

    def coldigits(col)
      result = []
      col.step(80, 9) do |i|
        v = @grid[i]
        result << v if v != 0
      end

      result
    end

    def boxdigits(box)
      boxes_indices = [0, 3, 6, 27, 30, 33, 54, 57, 60]

      i = boxes_indices[box]

      [
        @grid[i], @grid[i + 1], @grid[i + 2],
        @grid[i + 9], @grid[i + 10], @grid[i + 11],
        @grid[i + 18], @grid[i + 19], @grid[i + 20]
      ] - [0]
    end
  end
end
