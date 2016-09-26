require 'test_helper'

class ComparisonTest < ActiveSupport::TestCase
  test 'compare +100 to +75' do
    cmp = Comparison.new(100, 75)
    assert_in_delta(33.333, cmp.change)
  end

  test 'compare +75 to +100' do
    cmp = Comparison.new(75, 100)
    assert_in_delta(-25.000, cmp.change)
  end

  test 'compare -75 to +100' do
    cmp = Comparison.new(-75, 100)
    assert_in_delta(-175.000, cmp.change)
  end

  test 'compare +100 to -75' do
    cmp = Comparison.new(100, -75)
    assert_in_delta(233.333, cmp.change)
  end

  test 'compare -100 to -75' do
    cmp = Comparison.new(-100, -75)
    assert_in_delta(-33.333, cmp.change)
  end

  test 'compare -75 to -100' do
    cmp = Comparison.new(-75, -100)
    assert_in_delta(25.000, cmp.change)
  end

  test 'compare +100 to +100' do
    cmp = Comparison.new(100, 100)
    assert_equal(0, cmp.change)
  end

  test 'compare 0 to 0' do
    cmp = Comparison.new(0, 0)
    assert cmp.change.nan?, 'Comparison#change should be NaN'
  end

  test 'compare +100 to 0' do
    cmp = Comparison.new(100, 0)
    assert cmp.change.infinite?, 'Comparison#change should be infinite'
  end

  test 'compare -100 to 0' do
    cmp = Comparison.new(-100, 0)
    assert cmp.change.infinite?, 'Comparison#change should be infinite'
  end
end
