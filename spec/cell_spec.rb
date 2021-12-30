require 'spec_helper'

module Sudoku
  describe Cell do
    context '#initialize' do
      it "is initialized with a value of '' by default" do
        cell = Cell.new
        expect(cell.value).to eq ''
      end

      it 'can be initialized with a value of integer' do
        cell = Cell.new(5)
        expect(cell.value).to eq 5
      end
    end
  end
end
