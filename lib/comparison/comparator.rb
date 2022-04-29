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

    delegate %i[negative? positive? zero? nonzero?] => :absolute
    delegate %i[infinite? nan?] => :relative

    ##
    # Returns the difference between +@value+ and +@other+.
    def absolute
      @absolute ||= value - other
    end

    alias difference absolute

    ##
    # Returns the percentage difference of +@value+ to +@other+.
    def relative
      @relative ||= difference / other.abs * 100
    end

    alias percentage relative

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
