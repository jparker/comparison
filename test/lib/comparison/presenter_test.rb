# frozen-string-literal: true

require 'test_helper'

module Comparison
  # rubocop:disable Metrics/ClassLength
  class PresenterTest < ActiveSupport::TestCase
    setup do
      # rubocop:disable Style/ParallelAssignment
      @backend, I18n.backend = I18n.backend, I18n::Backend::KeyValue.new({})
      # rubocop:enable Style/ParallelAssignment
      I18n.enforce_available_locales = false
    end

    teardown do
      I18n.backend = @backend
    end

    test 'difference_as_currency with negative difference' do
      cmp = presenter 1_000, 2_000
      assert_equal '-$1,000.00', cmp.difference_as_currency
    end

    test 'difference_as_currency with positive difference' do
      cmp = presenter 2_000, 1_000
      assert_equal '+$1,000.00', cmp.difference_as_currency
    end

    test 'difference_as_currency with no difference' do
      cmp = presenter 100, 100
      assert_equal '$0.00', cmp.difference_as_currency
    end

    test 'difference is deprecated' do
      cmp = presenter 1, 100
      Kernel.expects(:warn).with { |msg| msg =~ /\ADEPRECATION WARNING:/ }
      assert_equal '-$99.00', cmp.difference
    end

    test 'percentage is negative' do
      cmp = presenter 1_000, 2_000
      assert_equal '-50%', cmp.percentage
    end

    test 'percentage is positive' do
      cmp = presenter 1_100, 100
      assert_equal '+1,000%', cmp.percentage
    end

    test 'percentage is zero' do
      cmp = presenter 1, 1
      assert_equal '0%', cmp.percentage
    end

    test 'percentage is not a number' do
      cmp = presenter 0, 0
      assert_equal '0%', cmp.percentage
    end

    test 'percentage is infinite' do
      cmp = presenter 1, 0
      assert_nil cmp.percentage
    end

    test 'infinite percentage with i18n translation' do
      I18n.backend.store_translations :en, comparison: { infinity_html: '&infin;' }
      cmp = presenter 1, 0
      assert_equal '&infin;', cmp.percentage
    end

    test 'percentage with overridden delimiter' do
      cmp = presenter 11, 1
      assert_equal '+1000%', cmp.percentage(delimiter: nil)
    end

    test 'percentage with overridden precision' do
      cmp = presenter 100, 75
      assert_equal '+33.33%', cmp.percentage(precision: 2)
    end

    test 'percentage with miscellaneous options' do
      cmp = presenter 100, 75
      assert_equal '33%', cmp.percentage(format: '%n%')
    end

    test 'unsigned negative percentage' do
      cmp = presenter 50, 75
      assert_equal '33%', cmp.unsigned_percentage
    end

    test 'unsigned positive percentage' do
      cmp = presenter 75, 50
      assert_equal '50%', cmp.unsigned_percentage
    end

    test 'icon with negative difference' do
      icon = '<span class="glyphicon glyphicon-arrow-down"></span>'
      I18n.backend.store_translations :en, comparison: { icons: { negative_html: icon } }
      cmp = negative
      assert_equal icon, cmp.icon
      assert cmp.icon.html_safe?, 'Comparator#icon should be html-safe'
    end

    test 'icon with positive difference' do
      icon = '<span class="glyphicon glyphicon-arrow-up"></span>'
      I18n.backend.store_translations :en, comparison: { icons: { positive_html: icon } }
      cmp = positive
      assert_equal icon, cmp.icon
      assert cmp.icon.html_safe?, 'Comparator#icon should be html-safe'
    end

    test 'icon with zero difference' do
      icon = '<span class="glyphicon glyphicon-minus"></span>'
      I18n.backend.store_translations :en, comparison: { icons: { nochange_html: icon } }
      cmp = nochange
      assert_equal icon, cmp.icon
      assert cmp.icon.html_safe?, 'Comparator#icon should be html-safe'
    end

    test 'arrow with negative difference' do
      arrow = '&darr;'
      I18n.backend.store_translations :en, comparison: { arrows: { negative_html: arrow } }
      cmp = negative
      assert_equal arrow, cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparator#arrow should be html-safe'
    end

    test 'arrow with positive difference' do
      arrow = '&uarr;'
      I18n.backend.store_translations :en, comparison: { arrows: { positive_html: arrow } }
      cmp = positive
      assert_equal arrow, cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparator#arrow should be html-safe'
    end

    test 'arrow with zero difference' do
      arrow = ''
      I18n.backend.store_translations :en, comparison: { arrows: { nochange_html: arrow } }
      cmp = nochange
      assert_equal arrow, cmp.arrow
      assert cmp.arrow.html_safe?, 'Comparator#arrow should be html-safe'
    end

    test 'dom_classes with negative difference' do
      classes = 'comparison negative'
      I18n.backend.store_translations :en, comparison: { dom_classes: { negative: classes } }
      assert_equal classes, negative.dom_classes
    end

    test 'dom_classes with positive difference' do
      classes = 'comparison positive'
      I18n.backend.store_translations :en, comparison: { dom_classes: { positive: classes } }
      assert_equal classes, positive.dom_classes
    end

    test 'dom_classes with zero difference' do
      classes = 'comparison nochange'
      I18n.backend.store_translations :en, comparison: { dom_classes: { nochange: classes } }
      assert_equal classes, nochange.dom_classes
    end

    test 'dom_classes with negative difference falls back on "classes" i18n key' do
      classes = 'comparison negative'
      I18n.backend.store_translations :en, comparison: { classes: { negative: classes } }
      assert_equal classes, negative.dom_classes
    end

    test 'dom_classes with positive difference falls back on "classes" i18n key' do
      classes = 'comparison positive'
      I18n.backend.store_translations :en, comparison: { classes: { positive: classes } }
      assert_equal classes, positive.dom_classes
    end

    test 'dom_classes with zero difference falls back on "classes" i18n key' do
      classes = 'comparison nochange'
      I18n.backend.store_translations :en, comparison: { classes: { nochange: classes } }
      assert_equal classes, nochange.dom_classes
    end

    test 'inline_style with negative difference' do
      style = 'color: #fff; background-color: #0a0;'
      I18n.backend.store_translations :en, comparison: { inline_style: { negative: style } }
      assert_equal style, negative.inline_style
    end

    test 'inline_style with negative difference defaults to empty string' do
      assert_equal '', negative.inline_style
    end

    test 'inline_style with positive difference' do
      style = 'color: #fff; background-color: #a00;'
      I18n.backend.store_translations :en, comparison: { inline_style: { positive: style } }
      assert_equal style, positive.inline_style
    end

    test 'inline_style with positive difference defaults to empty string' do
      assert_equal '', positive.inline_style
    end

    test 'inline_style with zero difference' do
      style = 'color: #777;'
      I18n.backend.store_translations :en, comparison: { inline_style: { nochange: style } }
      assert_equal style, nochange.inline_style
    end

    test 'inline_style with negative difference falls back on "style" i18n key' do
      style = 'color: #fff; background-color: #0a0;'
      I18n.backend.store_translations :en, comparison: { style: { negative: style } }
      assert_equal style, negative.inline_style
    end

    test 'inline_style with positive difference falls back on "style" i18n key' do
      style = 'color: #fff; background-color: #a00;'
      I18n.backend.store_translations :en, comparison: { style: { positive: style } }
      assert_equal style, positive.inline_style
    end

    test 'inline_style with zero difference falls back on "style" i18n key' do
      style = 'color: #777;'
      I18n.backend.store_translations :en, comparison: { style: { nochange: style } }
      assert_equal style, nochange.inline_style
    end

    test 'inline_style with negative difference falls back on "css" i18n key' do
      style = 'color: #fff; background-color: #0a0;'
      I18n.backend.store_translations :en, comparison: { css: { negative: style } }
      assert_equal style, negative.inline_style
    end

    test 'inline_style with positive difference falls back on "css" i18n key' do
      style = 'color: #fff; background-color: #a00;'
      I18n.backend.store_translations :en, comparison: { css: { positive: style } }
      assert_equal style, positive.inline_style
    end

    test 'inline_style with zero difference falls back on "css" i18n key' do
      style = 'color: #777;'
      I18n.backend.store_translations :en, comparison: { css: { nochange: style } }
      assert_equal style, nochange.inline_style
    end

    test 'inline_style with zero difference defaults to empty string' do
      assert_equal '', nochange.inline_style
    end

    test 'description with negative difference' do
      assert_equal 'negative', negative.description
    end

    test 'description with positive difference' do
      assert_equal 'positive', positive.description
    end

    test 'description with zero difference' do
      assert_equal 'nochange', nochange.description
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

    def presenter(value, other)
      Presenter.new Comparator.new value, other
    end
  end
  # rubocop:enable Metrics/ClassLength
end
