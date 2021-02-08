# frozen-string-literal: true

require 'bigdecimal'
require 'forwardable'

module Comparison
  ##
  # The Comparator object compares two numbers to each other and exposes the
  # raw and percentage differences.
  class Comparator
    extend Forwardable

    ##
    # Instantiates a new Comparator to compare two numbers, +m+ and +n+.
    #
    # Both numbers will be converted to instances of `BigDecimal`.
    #
    # rubocop:disable Naming/MethodParameterName
    def initialize(m, n)
      @m = m.to_d
      @n = n.to_d
    end
    # rubocop:enable Naming/MethodParameterName

    attr_reader :m, :n

    delegate %i[negative? positive? zero? nonzero?] => :absolute
    delegate %i[infinite? nan?] => :relative

    ##
    # Returns the difference between +@m+ and +@n+.
    def absolute
      @absolute ||= m - n
    end

    alias difference absolute

    ##
    # Returns the percentage difference of +@m+ to +@n+.
    def relative
      @relative ||= difference / n.abs * 100
    end

    alias percentage relative
  end
end
