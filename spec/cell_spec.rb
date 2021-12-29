require 'spec_helper'

module Sudoku
  describe Cell do
    context '#initialize' do
      it "is initialized with a value of '' by default" do
        cell = Cell.new
        expect(cell.value).to eq ''
      end

      it "can be initialized with a value of '0'" do
        cell = Cell.new(0)
        expect(cell.value).to eq 0
      end
    end
  end
end
