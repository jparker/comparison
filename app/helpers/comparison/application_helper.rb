# frozen-string-literal: true

module Comparison
  module ApplicationHelper # :nodoc:
    ##
    # Returns a Presenter for a Comparator for +value+ and +other+.
    #
    # If a block is given, the Presenter is yielded to the block.
    def compare(value, other)
      comparison = Presenter.new Comparator.new value, other
      yield comparison if block_given?
      comparison
    end
  end
end
