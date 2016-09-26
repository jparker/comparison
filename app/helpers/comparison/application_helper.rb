module Comparison
  module ApplicationHelper
    def compare(m, n)
      comparison = Presenter.new Comparator.new m, n
      yield comparison if block_given?
      comparison
    end
  end
end
