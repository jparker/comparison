require 'test_helper'

module Comparison
  class PresenterTest < ActiveSupport::TestCase
    def setup
      @backend, I18n.backend = I18n.backend, I18n::Backend::KeyValue.new({})
      I18n.enforce_available_locales = false
    end

    def teardown
      I18n.backend = @backend
    end

    def test_difference_negative
      cmp = presenter 1_000, 2_000
      assert_equal '-$1,000.00', cmp.difference
    end

    def test_difference_positive
      cmp = presenter 2_000, 1_000
      assert_equal '+$1,000.00', cmp.difference
    end

    def test_difference_zero
      cmp = presenter 100, 100
      assert_equal '$0.00', cmp.difference
    end

    def test_percentage_negative
      cmp = presenter 1_000, 2_000
      assert_equal '-50%', cmp.percentage
    end

    def test_percentage_positive
      cmp = presenter 1_100, 100
      assert_equal '+1,000%', cmp.percentage
    end

    def test_percentage_zero
      cmp = presenter 1, 1
      assert_equal '0%', cmp.percentage
    end

    def test_percentage_nan
      cmp = presenter 0, 0
      assert_equal '0%', cmp.percentage
    end

    def test_percentage_infinity
      cmp = presenter 1, 0
      assert_nil cmp.percentage
    end

    def test_percentage_delimiter_option
      cmp = presenter 11, 1
      assert_equal '+1000%', cmp.percentage(delimiter: nil)
    end

    def test_percentage_precision_option
      cmp = presenter 100, 75
      assert_equal '+33.33%', cmp.percentage(precision: 2)
    end

    def test_percentage_miscellaneous_options
      cmp = presenter 100, 75
      assert_equal '33%', cmp.percentage(format: '%n%')
    end

    def test_arrow_negative
      arrow = '&darr;'
      I18n.backend.store_translations :en,
        { comparison: { arrows: { negative_html: arrow } } }
      cmp = negative
      assert_equal arrow, cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparator#arrow should be html-safe'
    end

    def test_arrow_positive
      arrow = '&uarr;'
      I18n.backend.store_translations :en,
        { comparison: { arrows: { positive_html: arrow } } }
      cmp = positive
      assert_equal arrow, cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparator#arrow should be html-safe'
    end

    def test_arrow_no_change
      arrow = ''
      I18n.backend.store_translations :en,
        { comparison: { arrows: { nochange_html: arrow } } }
      cmp = nochange
      assert_equal arrow, cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparator#arrow should be html-safe'
    end

    def test_css_negative
      css = 'color: #a94442; background-color: #f2dede;'
      I18n.backend.store_translations :en,
        { comparison: { css: { negative: css } } }
      cmp = negative
      assert_equal css, cmp.css
    end

    def test_css_positive
      css = 'color: #3c763d; background-color: #dff0d8;'
      I18n.backend.store_translations :en,
        { comparison: { css: { positive: css } } }
      cmp = positive
      assert_equal css, cmp.css
    end

    def test_css_no_change
      css = 'color: #777777;'
      I18n.backend.store_translations :en,
        { comparison: { css: { nochange: css } } }
      cmp = nochange
      assert_equal css, cmp.css
    end

    def positive
      presenter 100, 75
    end

    def negative
      presenter 75, 100
    end

    def nochange
      presenter 75, 75
    end

    def presenter(m, n)
      Presenter.new Comparator.new m, n
    end
  end
end
