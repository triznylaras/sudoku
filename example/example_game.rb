require_relative '../lib/sudoku'

sudoku_gen = Sudoku::SudokuGen.new
puts 'Welcome to Sudoku Game!'
output = sudoku_gen.grid.each_slice(9).to_a
output.each do |row|
  puts row.map! { |val| val.zero? ? '_' : val }.join(' ')
end
