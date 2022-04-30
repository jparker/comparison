# frozen-string-literal: true

require 'bigdecimal'
require 'forwardable'

module Comparison
  ##
  # The Comparator object compares two numbers to each other and exposes the
  # raw and percentage differences.
  class Comparator
    extend Forwardable

    attr_reader :value, :other

    ##
    # Instantiates a new Comparator to compare two numbers, +value+ and +other+.
    #
    # Both numbers will be converted to instances of `BigDecimal`.
    def initialize(value, other)
      @value = value.to_d
      @other = other.to_d
    end

    delegate %i[negative? positive? zero? nonzero?] => :difference
    delegate %i[infinite? nan?] => :change

    ##
    # Returns the difference between +@value+ and +@other+.
    def difference
      value - other
    end

    def absolute
      Kernel.warn "DEPRECATION WARNING: use #difference instead of #absolute (called from #{caller(1..1).first})"
      difference
    end

    ##
    # Returns the relative change of +@value+ from +@other+.
    def change
      difference / other.abs
    end

    ##
    # Returns the relative change of +@value+ from +@other+ as a percentage.
    def percentage
      change * 100
    end

    def relative
      Kernel.warn "DEPRECATION WARNING: use #percentage instead of #relative (called from #{caller(1..1).first})"
      change
    end

    def m
      Kernel.warn "DEPRECATION WARNING: use #value instead of #m (called from #{caller(1..1).first})"
      value
    end

    def n
      Kernel.warn "DEPRECATION WARNING: use #other instead of #n (called from #{caller(1..1).first})"
      other
    end
  end
end
