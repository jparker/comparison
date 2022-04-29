# frozen-string-literal: true

require 'delegate'

module Comparison
  ##
  # The Presenter object wraps a Comparator with methods that return
  # view-friendly output.
  class Presenter < DelegateClass(Comparator)
    include ActionView::Helpers::TranslationHelper

    ARROWS = { positive: '&uarr;', negative: '&darr;', nochange: '' }.freeze

    ##
    # Returns Comparator#absolute presented as currency.
    def difference(**options)
      if positive?
        number_to_currency absolute, format: '+%u%n', **options
      else
        number_to_currency absolute, **options
      end
    end

    ##
    # Returns Comparator#relative formatted as a percentage.
    #
    # If the relative percentage evaluates to Infinity or -Infinity, +nil+ is
    # returned. If it evaluates to NaN, 0 is returned.
    def percentage(**options)
      if nan? || zero?
        number_to_percentage 0, **options
      elsif infinite?
        t 'comparison.infinity_html', default: nil
      elsif positive?
        number_to_percentage relative, format: '+%n%', **options
      else
        number_to_percentage relative, **options
      end
    end

    ##
    # Returns the absolute value of Comparator#relative formatted as a percentage.
    #
    # Use this if you are relying on other cues (colors and/or icons) to
    # indicate positive or negative values.
    def unsigned_percentage(**options)
      if nan? || zero?
        number_to_percentage 0, **options
      elsif infinite?
        t 'comparison.infinity_html', default: nil
      else
        number_to_percentage relative.abs, **options
      end
    end

    ##
    # Returns the I18n translation for `comparison.icons`. (See also #arrow.)
    #
    # This method is intended to display a graphical representation of the
    # comparison. Typically this would be an arrow pointing up or down.
    #
    # No default implementation is included. You must provide the translations
    # yourself or you will get missing translations.
    #
    # For example, to generate up and down arrows using Glyphicons included
    # with Bootstrap, you could add the following translations to your
    # application:
    #
    #     en:
    #       comparison:
    #         icons:
    #           positive_html: '<span class="glyphicon glyphicon-arrow-up"></span>'
    #           negative_html: '<span class="glyphicon glyphicon-arrow-down"></span>'
    #           nochange_html: '<span class="glyphicon glyphicon-minus"></span>'
    #
    def icon
      key, = expand_i18n_keys 'icons', suffix: '_html'
      t key
    end

    ##
    # Returns the I18n translation for `comparison.icons`. (See also #icon.)
    #
    # This method is intended to display a graphical representation of the
    # comparison. Typically this would be an arrow pointing up or down.
    #
    # The default implementation is as follows:
    #
    #     en:
    #       comparison:
    #         arrows:
    #           positive_html: '&uarr;'
    #           negative_html: '&darr;'
    #           nochange_html: ''
    #
    # For example, to generate up and down arrows using Glyphicons included
    # with Bootstrap, you could add the following translations to your
    # application:
    #
    # #arrows and its sister method #icon perform roughly identical tasks with
    # roughly identical intentions. The difference between the two methods is
    # in the context in which they are intended to be used.
    #
    # #arrows is meant to be used from view contexts with limited functionality
    # such as an HTML email. As such, the translations you specify should be
    # simple enough, like HTML character entities, to work within said view
    # context.
    #
    # #icons is meant to be used from full-featured view contexts. As such,
    # #icons is the one to use to generate HTML tags.
    def arrow
      key, = expand_i18n_keys 'arrows', suffix: '_html'
      t key, default: ARROWS[description.to_sym]
    end

    ##
    # Returns the I18n translation for `comparison.dom_classes`.
    #
    # Use these translations to specify CSS classes for tags that contain
    # comparison data. For example:
    #
    #     en:
    #       comparison:
    #         dom_classes:
    #           positive: 'comparison positive'
    #           negative: 'comparison negative'
    #           nochange: 'comparison nochange'
    #
    #     .comparison.positive {
    #       color: #3c763d;
    #       background-color: #dff0d8;
    #     }
    #     .comparison.negative {
    #       color: #a94442;
    #       background-color: #f2dede;
    #     }
    #     .comparison.nochange {
    #       color: #777777;
    #     }
    #
    #     content_tag :span, cmp.difference, class: cmp.dom_classes
    #     # => "<span class=\"comparison positive\">+10%</span>"
    #
    # If you need to work with inline styles instead of CSS classes, see the
    # `#inline_style` method.
    def dom_classes
      key, *deprecated_keys = expand_i18n_keys(%w[dom_classes classes])
      t key, default: deprecated_keys
    end

    def classes
      Kernel.warn "DEPRECATION WARNING: use #dom_classes instead of #classes (called from #{caller(3..3).first})"
      dom_classes
    end

    ##
    # Returns the I18n translation for `comparison.style`.
    #
    # Use these translations to specify inline CSS style rules to be used when
    # formatting comparison data. For example:
    #
    #     en:
    #       comparison:
    #         inline_style:
    #           positive: 'color: #3c763d; background-color: #dff0d8;'
    #           negative: 'color: #a94442; background-color: #f2dede;'
    #           nochange: 'color: #777777;'
    #
    #     content_tag :span, cmp.difference, style: cmp.inline_style
    #     # => "<span style=\"color: #3c763d; background-color: #dff0d8;\">+10%</span>"
    #
    # In general, it's probably preferable to use `#dom_classes` in conjunction
    # with CSS style rules defined separate CSS files, but this isn't always
    # possible.
    #
    def inline_style
      key, *deprecated_keys = expand_i18n_keys(%w[inline_style style css])
      t key, default: [*deprecated_keys, '']
    end

    alias style inline_style

    def css
      Kernel.warn "DEPRECATION WARNING: use #inline_style instead of #css (called from #{caller(3..3).first})"
      inline_style
    end

    ##
    # Returns a string description of the direction of change. Possible
    # descriptions are "positive", "negative", and "nochange".
    def description
      if positive?
        'positive'
      elsif negative?
        'negative'
      else
        'nochange'
      end
    end

    private

    def number_to_percentage(value, **options)
      options = { delimiter: ',', precision: 0, **options }
      ActiveSupport::NumberHelper.number_to_percentage value, options
    end

    def number_to_currency(*args)
      ActiveSupport::NumberHelper.number_to_currency(*args)
    end

    def expand_i18n_keys(names, suffix: nil)
      Array(names).map { |name| :"comparison.#{name}.#{description}#{suffix}" }
    end
  end
end
