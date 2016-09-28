module Comparison
  module ApplicationHelper
    ##
    # Returns a Presenter for a Comparator for +m+ and +n+.
    #
    # If a block is given, the Presenter is yielded to the block.
    def compare(m, n)
      comparison = Presenter.new Comparator.new m, n
      yield comparison if block_given?
      comparison
    end
  end
end
