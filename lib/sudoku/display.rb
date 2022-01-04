module Display
  def display_rules
    <<~HEREDOC
      Welcome to Sudoku game!

      Sudoku is a puzzle based on a small number of very simple rules:

      \e[33m(1)\e[0m Every square has to contain a single number
      \e[33m(2)\e[0m Only the numbers from 1 through to 9 can be used
      \e[33m(3)\e[0m Each 3×3 box can only contain each number from 1 to 9 once
      \e[33m(4)\e[0m Each vertical column can only contain each number from 1 to 9 once
      \e[33m(5)\e[0m Each horizontal row can only contain each number from 1 to 9 once

      Once the puzzle is solved, this means that every row, column, and 3×3 box will contain every number from 1 to 9 exactly once. 

      In other words, no number can be repeated in any 3×3 box, row, or column. 

    HEREDOC
  end


end
