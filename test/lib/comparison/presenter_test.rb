require 'test_helper'

class Comparison
  class PresenterTest < ActiveSupport::TestCase
    def test_presenting_negative_percentage
      cmp = Presenter.new Comparison.new 1, 2
      assert_equal '-50%', cmp.percentage
    end

    def test_presenting_positive_percentage
      cmp = Presenter.new Comparison.new 11, 1
      assert_equal '+1,000%', cmp.percentage
    end

    def test_presenting_0
      cmp = Presenter.new Comparison.new 1, 1
      assert_equal '0%', cmp.percentage
    end

    def test_presenting_NaN
      cmp = Presenter.new Comparison.new 0, 0
      assert_equal '0%', cmp.percentage
    end

    def test_presenting_infinity
      cmp = Presenter.new Comparison.new 1, 0
      assert_nil cmp.percentage
    end

    def test_delimiter_option
      cmp = Presenter.new Comparison.new 11, 1
      assert_equal '+1000%', cmp.percentage(delimiter: nil)
    end

    def test_precision_option
      cmp = Presenter.new Comparison.new 100, 75
      assert_equal '+33.33%', cmp.percentage(precision: 2)
    end

    def test_miscellaneous_options
      cmp = Presenter.new Comparison.new 100, 75
      assert_equal '33%', cmp.percentage(format: '%n%')
    end

    def test_up_arrow
      cmp = Presenter.new Comparison.new 100, 75
      assert_equal '&uarr;', cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparison#arrow should be html-safe'
    end

    def test_down_arrow
      cmp = Presenter.new Comparison.new 100, 75
      assert_equal '&uarr;', cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparison#arrow should be html-safe'
    end

    def test_no_change_arrow
      cmp = Presenter.new Comparison.new 75, 75
      assert_nil cmp.arrow
    end
  end
end
