# frozen-string-literal: true

require 'bigdecimal'
require 'forwardable'

module Comparison
  class Comparator
    extend Forwardable

    ##
    # Instantiates a new Comparator to compare two numbers, +m+ and +n+.
    def initialize(m, n)
      @m = m.to_d
      @n = n.to_d
    end

    attr_reader :m, :n

    delegate %i[infinite? nan? negative? positive? zero?] => :relative

    ##
    # Returns the difference between +@m+ and +@n+.
    def absolute
      @absolute ||= m - n
    end

    alias_method :difference, :absolute

    ##
    # Returns the percentage difference of +@m+ to +@n+.
    def relative
      @relative ||= if n.negative?
                      (1 - m / n) * 100
                    else
                      (m / n - 1) * 100
                    end
    end

    alias_method :percentage, :relative
  end
end
