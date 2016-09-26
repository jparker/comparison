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

    delegate %i[infinite? nan? negative? positive? zero?] => :change

    def direction
      case
      when positive?
        :up
      when negative?
        :down
      else
        :none
      end
    end

    def difference
      @difference ||= m - n
    end
    alias_method :diff, :difference

    def change
      @change ||= if n.negative?
                    (1 - m / n) * 100
                  else
                    (m / n - 1) * 100
                  end
    end
    alias_method :chg, :change
  end
end
