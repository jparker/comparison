# frozen-string-literal: true

require 'test_helper'

module Comparison
  # rubocop:disable Metrics/ClassLength
  class PresenterTest < ActiveSupport::TestCase
    def setup
      # rubocop:disable Style/ParallelAssignment
      @backend, I18n.backend = I18n.backend, I18n::Backend::KeyValue.new({})
      # rubocop:enable Style/ParallelAssignment
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

    def test_icon_negative
      icon = '<span class="glyphicon glyphicon-arrow-down"></span>'
      I18n.backend.store_translations :en,
        comparison: { icons: { negative_html:  icon } }
      cmp = negative
      assert_equal icon, cmp.icon
      assert cmp.icon.html_safe?, 'Comparator#icon should be html-safe'
    end

    def test_icon_positive
      icon = '<span class="glyphicon glyphicon-arrow-up"></span>'
      I18n.backend.store_translations :en,
        comparison: { icons: { positive_html:  icon } }
      cmp = positive
      assert_equal icon, cmp.icon
      assert cmp.icon.html_safe?, 'Comparator#icon should be html-safe'
    end

    def test_icon_no_change
      icon = '<span class="glyphicon glyphicon-minus"></span>'
      I18n.backend.store_translations :en,
        comparison: { icons: { nochange_html:  icon } }
      cmp = nochange
      assert_equal icon, cmp.icon
      assert cmp.icon.html_safe?, 'Comparator#icon should be html-safe'
    end

    def test_arrow_negative
      arrow = '&darr;'
      I18n.backend.store_translations :en,
        comparison: { arrows: { negative_html: arrow } }
      cmp = negative
      assert_equal arrow, cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparator#arrow should be html-safe'
    end

    def test_arrow_positive
      arrow = '&uarr;'
      I18n.backend.store_translations :en,
        comparison: { arrows: { positive_html: arrow } }
      cmp = positive
      assert_equal arrow, cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparator#arrow should be html-safe'
    end

    def test_arrow_no_change
      arrow = ''
      I18n.backend.store_translations :en,
        comparison: { arrows: { nochange_html: arrow } }
      cmp = nochange
      assert_equal arrow, cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparator#arrow should be html-safe'
    end

    def test_dom_classes_negative
      classes = 'comparison negative'
      I18n.backend.store_translations :en,
        comparison: { dom_classes: { negative: classes } }
      assert_equal classes, negative.dom_classes
    end

    def test_dom_classes_negative_falls_back_on_classes
      classes = 'comparison negative'
      I18n.backend.store_translations :en,
        comparison: { classes: { negative: classes } }
      assert_equal classes, negative.dom_classes
    end

    def test_dom_classes_positive
      classes = 'comparison positive'
      I18n.backend.store_translations :en,
        comparison: { dom_classes: { positive: classes } }
      assert_equal classes, positive.dom_classes
    end

    def test_dom_classes_positive_falls_back_on_classes
      classes = 'comparison positive'
      I18n.backend.store_translations :en,
        comparison: { classes: { positive: classes } }
      assert_equal classes, positive.dom_classes
    end

    def test_dom_classes_nochange
      classes = 'comparison nochange'
      I18n.backend.store_translations :en,
        comparison: { dom_classes: { nochange: classes } }
      assert_equal classes, nochange.dom_classes
    end

    def test_dom_classes_nochange_falls_back_on_classes
      classes = 'comparison nochange'
      I18n.backend.store_translations :en,
        comparison: { classes: { nochange: classes } }
      assert_equal classes, nochange.dom_classes
    end

    def test_style_negative
      style = 'color: #fff; background-color: #0a0;'
      I18n.backend.store_translations :en,
        comparison: { style: { negative: style } }
      assert_equal style, negative.style
    end

    def test_style_negative_falls_back_on_css
      style = 'color: #fff; background-color: #0a0;'
      I18n.backend.store_translations :en,
        comparison: { css: { negative: style } }
      assert_equal style, negative.style
    end

    def test_style_negative_defaults_to_empty_string
      assert_equal '', negative.style
    end

    def test_style_positive
      style = 'color: #fff; background-color: #a00;'
      I18n.backend.store_translations :en,
        comparison: { style: { positive: style } }
      assert_equal style, positive.style
    end

    def test_style_positive_falls_back_on_css
      style = 'color: #fff; background-color: #a00;'
      I18n.backend.store_translations :en,
        comparison: { css: { positive: style } }
      assert_equal style, positive.style
    end

    def test_style_positive_defaults_to_empty_string
      assert_equal '', positive.style
    end

    def test_style_no_change
      style = 'color: #777;'
      I18n.backend.store_translations :en,
        comparison: { style: { nochange: style } }
      assert_equal style, nochange.style
    end

    def test_style_no_change_falls_back_on_css
      style = 'color: #777;'
      I18n.backend.store_translations :en,
        comparison: { css: { nochange: style } }
      assert_equal style, nochange.style
    end

    def test_style_no_change_defaults_to_empty_string
      assert_equal '', nochange.style
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

    # rubocop:disable Naming/UncommunicativeMethodParamName
    def presenter(m, n)
      Presenter.new Comparator.new m, n
    end
    # rubocop:enable Naming/UncommunicativeMethodParamName
  end
  # rubocop:enable Metrics/ClassLength
end
