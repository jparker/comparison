# frozen-string-literal: true

require 'test_helper'

module Comparison
  class ComparatorTest < ActiveSupport::TestCase
    test 'compare +100 to +75' do
      cmp = Comparator.new(100, 75)
      assert_equal(+25, cmp.absolute)
      assert_in_delta(+33.333, cmp.relative)
    end

    test 'compare +75 to +100' do
      cmp = Comparator.new(75, 100)
      assert_equal(-25, cmp.absolute)
      assert_in_delta(-25.000, cmp.relative)
    end

    test 'compare -75 to +100' do
      cmp = Comparator.new(-75, 100)
      assert_in_delta(-175.000, cmp.relative)
    end

    test 'compare +100 to -75' do
      cmp = Comparator.new(100, -75)
      assert_in_delta(+233.333, cmp.relative)
    end

    test 'compare -100 to -75' do
      cmp = Comparator.new(-100, -75)
      assert_in_delta(-33.333, cmp.relative)
    end

    test 'compare -75 to -100' do
      cmp = Comparator.new(-75, -100)
      assert_in_delta(+25.000, cmp.relative)
    end

    test 'compare +100 to +100' do
      cmp = Comparator.new(100, 100)
      assert_equal(0, cmp.relative)
    end

    test 'compare 0 to 0' do
      cmp = Comparator.new(0, 0)
      assert_equal(0, cmp.absolute)
      assert cmp.relative.nan?, 'Comparator#relative should be NaN'
    end

    test 'compare +100 to 0' do
      cmp = Comparator.new(+100, 0)
      assert_equal(+100, cmp.absolute)
      assert cmp.relative.infinite?, 'Comparator#relative should be infinite'
    end

    test 'compare -100 to 0' do
      cmp = Comparator.new(-100, 0)
      assert_equal(-100, cmp.absolute)
      assert cmp.relative.infinite?, 'Comparator#relative should be infinite'
    end
  end
end
