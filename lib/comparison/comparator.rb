require 'bigdecimal'
require 'forwardable'

module Comparison
  class Comparator
    extend Forwardable

    def initialize(m, n)
      @m = m.to_d
      @n = n.to_d
    end

    attr_reader :m, :n

    delegate %i[infinite? nan? negative? positive? zero?] => :relative

    def absolute
      @absolute ||= m - n
    end

    alias_method :difference, :absolute

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
