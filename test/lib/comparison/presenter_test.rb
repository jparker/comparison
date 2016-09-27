require 'test_helper'

module Comparison
  class PresenterTest < ActiveSupport::TestCase
    def test_difference_negative
      cmp = Presenter.new Comparator.new 1_000, 2_000
      assert_equal '-$1,000.00', cmp.difference
    end

    def test_difference_positive
      cmp = Presenter.new Comparator.new 2_000, 1_000
      assert_equal '+$1,000.00', cmp.difference
    end

    def test_difference_zero
      cmp = Presenter.new Comparator.new 100, 100
      assert_equal '$0.00', cmp.difference
    end

    def test_percentage_negative
      cmp = Presenter.new Comparator.new 1_000, 2_000
      assert_equal '-50%', cmp.percentage
    end

    def test_percentage_positive
      cmp = Presenter.new Comparator.new 1_100, 100
      assert_equal '+1,000%', cmp.percentage
    end

    def test_percentage_zero
      cmp = Presenter.new Comparator.new 1, 1
      assert_equal '0%', cmp.percentage
    end

    def test_percentage_nan
      cmp = Presenter.new Comparator.new 0, 0
      assert_equal '0%', cmp.percentage
    end

    def test_percentage_infinity
      cmp = Presenter.new Comparator.new 1, 0
      assert_nil cmp.percentage
    end

    def test_percentage_delimiter_option
      cmp = Presenter.new Comparator.new 11, 1
      assert_equal '+1000%', cmp.percentage(delimiter: nil)
    end

    def test_percentage_precision_option
      cmp = Presenter.new Comparator.new 100, 75
      assert_equal '+33.33%', cmp.percentage(precision: 2)
    end

    def test_percentage_miscellaneous_options
      cmp = Presenter.new Comparator.new 100, 75
      assert_equal '33%', cmp.percentage(format: '%n%')
    end

    def test_arrow_negative
      cmp = Presenter.new Comparator.new 75, 100
      assert_equal '&darr;', cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparison#arrow should be html-safe'
    end

    def test_arrow_positive
      cmp = Presenter.new Comparator.new 100, 75
      assert_equal '&uarr;', cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparison#arrow should be html-safe'
    end

    def test_arrow_no_change
      cmp = Presenter.new Comparator.new 75, 75
      assert_equal '', cmp.arrow
    end
  end
end
