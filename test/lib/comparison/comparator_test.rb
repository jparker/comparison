# frozen-string-literal: true

require 'test_helper'

module Comparison
  class ComparatorTest < ActiveSupport::TestCase
    test 'store value as BigDecimal' do
      cmp = Comparator.new 100, 1
      assert_equal 100.to_d, cmp.value
      assert_instance_of BigDecimal, cmp.value
    end

    test 'store other as BigDecimal' do
      cmp = Comparator.new 100, 1
      assert_equal 1.to_d, cmp.other
      assert_instance_of BigDecimal, cmp.other
    end

    test 'compare 4 to 3' do
      cmp = Comparator.new 4, 3
      assert_equal 1, cmp.difference
      assert_in_delta 0.333, cmp.change
      assert_in_delta 33.333, cmp.percentage
    end

    test 'compare 3 to 4' do
      cmp = Comparator.new 3, 4
      assert_equal(-1, cmp.difference)
      assert_in_delta(-0.25, cmp.change)
      assert_in_delta(-25.000, cmp.percentage)
    end

    test 'compare -3 to 4' do
      cmp = Comparator.new(-3, 4)
      assert_equal(-7, cmp.difference)
      assert_in_delta(-1.75, cmp.change)
      assert_in_delta(-175.000, cmp.percentage)
    end

    test 'compare 4 to -3' do
      cmp = Comparator.new 4, -3
      assert_equal 7, cmp.difference
      assert_in_delta 2.333, cmp.change
      assert_in_delta 233.333, cmp.percentage
    end

    test 'compare -4 to -3' do
      cmp = Comparator.new(-4, -3)
      assert_equal(-1, cmp.difference)
      assert_in_delta(-0.333, cmp.change)
      assert_in_delta(-33.333, cmp.percentage)
    end

    test 'compare -3 to -4' do
      cmp = Comparator.new(-3, -4)
      assert_equal 1, cmp.difference
      assert_in_delta 0.25, cmp.change
      assert_in_delta 25.000, cmp.percentage
    end

    test 'compare 1 to 1' do
      cmp = Comparator.new 1, 1
      assert_equal 0, cmp.difference
      assert_equal 0, cmp.change
      assert_equal 0, cmp.percentage
    end

    test 'compare 0 to 0' do
      cmp = Comparator.new 0, 0
      assert_equal 0, cmp.difference
      assert_predicate cmp.change, :nan?
      assert_predicate cmp.percentage, :nan?
    end

    test 'compare 1 to 0' do
      cmp = Comparator.new 1, 0
      assert_equal 1, cmp.difference
      assert_predicate cmp.change, :infinite?
      assert_predicate cmp.change, :positive?
      assert_predicate cmp.percentage, :infinite?
    end

    test 'compare -1 to 0' do
      cmp = Comparator.new(-1, 0)
      assert_equal(-1, cmp.difference)
      assert_predicate cmp.change, :infinite?
      assert_predicate cmp.change, :negative?
      assert_predicate cmp.percentage, :infinite?
    end

    test 'delegates positive? to difference' do
      cmp = Comparator.new 100, 1
      assert_predicate cmp, :positive?
      refute_predicate cmp, :negative?
    end

    test 'delegates negative? to difference' do
      cmp = Comparator.new 1, 100
      assert_predicate cmp, :negative?
      refute_predicate cmp, :positive?
    end

    test 'delegates zero? to difference' do
      cmp = Comparator.new 1, 1
      assert_predicate cmp, :zero?
      refute_predicate cmp, :nonzero?
    end

    test 'delegates nonzero? to difference' do
      cmp = Comparator.new 1, 100
      refute_predicate cmp, :zero?
      assert_predicate cmp, :nonzero?
    end

    test 'delegates infinite? to change' do
      cmp = Comparator.new 100, 0
      assert_predicate cmp, :infinite?
    end

    test 'delegates nan? to change' do
      cmp = Comparator.new 0, 0
      assert_predicate cmp, :nan?
    end
  end
end
