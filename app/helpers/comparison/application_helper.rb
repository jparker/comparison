class Comparison
  module ApplicationHelper
    def compare(m, n)
      comparison = Presenter.new Comparison.new m, n
      yield comparison if block_given?
      comparison
    end
  end
end
