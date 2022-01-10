require_relative '../lib/sudoku'
require 'curses'

sudoku_gen = Sudoku::SudokuGen.new
output = sudoku_gen.grid.each_slice(9).to_a

output.each_with_index do |row, index|
  puts '+-------+-------+-------+' if [0, 3, 6].include?(index)
  row.map! { |val| val.zero? ? '.' : val }.join(' ')
  row.each_slice(3) do |k, l, m|
    new_arr = "| #{k} #{l} #{m} "
    print new_arr
  end
  print '|'
  puts
end
puts '+-------+-------+-------+'
