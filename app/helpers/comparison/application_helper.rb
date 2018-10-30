# frozen-string-literal: true

module Comparison
  module ApplicationHelper # :nodoc:
    ##
    # Returns a Presenter for a Comparator for +m+ and +n+.
    #
    # If a block is given, the Presenter is yielded to the block.
    #
    # rubocop:disable Naming/UncommunicativeMethodParamName
    def compare(m, n)
      comparison = Presenter.new Comparator.new m, n
      yield comparison if block_given?
      comparison
    end
    # rubocop:enable Naming/UncommunicativeMethodParamName
  end
end
