# frozen-string-literal: true

require 'delegate'

module Comparison
  ##
  # The Presenter object wraps a Comparator with methods that return
  # view-friendly output.
  class Presenter < DelegateClass(Comparator)
    include ActionView::Helpers::TranslationHelper

    ARROWS = { up: '&uarr;', down: '&darr;', none: '' }.freeze

    # TODO: This shouldn't necessarily return a currency representation.

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
        # TODO: Return nil, or lookup an optional representation in I18n?
        nil
      elsif positive?
        number_to_percentage relative, format: '+%n%', **options
      else
        number_to_percentage relative, **options
      end
    end

    # rubocop:disable Metrics/LineLength
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
    # rubocop:enable Metrics/LineLength
    def icon
      if positive?
        t 'comparison.icons.positive_html'
      elsif negative?
        t 'comparison.icons.negative_html'
      else
        t 'comparison.icons.nochange_html'
      end
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
      if positive?
        t 'comparison.arrows.positive_html', default: ARROWS[:up]
      elsif negative?
        t 'comparison.arrows.negative_html', default: ARROWS[:down]
      else
        t 'comparison.arrows.nochange_html', default: ARROWS[:none]
      end
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
    # `#style` method.
    def dom_classes
      if positive?
        t 'comparison.dom_classes.positive',
          default: %i[comparison.classes.positive]
      elsif negative?
        t 'comparison.dom_classes.negative',
          default: %i[comparison.classes.negative]
      else
        t 'comparison.dom_classes.nochange',
          default: %i[comparison.classes.nochange]
      end
    end

    def classes
      Kernel.warn '[DEPRECATION WARNING] #classes is deprecated: ' \
        "use #dom_classes instead: #{caller(3..3).first}"
      dom_classes
    end

    # rubocop:disable Metrics/LineLength
    ##
    # Returns the I18n translation for `comparison.style`.
    #
    # Use these translations to specify inline CSS style rules to be used when
    # formatting comparison data. For example:
    #
    #     en:
    #       comparison:
    #         style:
    #           positive: 'color: #3c763d; background-color: #dff0d8;'
    #           negative: 'color: #a94442; background-color: #f2dede;'
    #           nochange: 'color: #777777;'
    #
    #     content_tag :span, cmp.difference, style: cmp.style
    #     # => "<span style=\"color: #3c763d; background-color: #dff0d8;\">+10%</span>"
    #
    # In general, it's probably preferable to use `#dom_classes` in conjunction
    # with CSS style rules defined separate CSS files, but this isn't always
    # possible.
    #
    # rubocop:enable Metrics/LineLength
    def style
      if positive?
        t 'comparison.style.positive',
          default: [:'comparison.css.positive', '']
      elsif negative?
        t 'comparison.style.negative',
          default: [:'comparison.css.negative', '']
      else
        t 'comparison.style.nochange',
          default: [:'comparison.css.nochange', '']
      end
    end

    def css
      Kernel.warn '[DEPRECATION WARNING] #css is deprecated: ' \
        "use #style instead: #{caller(3..3).first}"
      style
    end

    private

    def number_to_percentage(value, delimiter: ',', precision: 0, **options)
      ActiveSupport::NumberHelper.number_to_percentage value,
        delimiter: delimiter,
        precision: precision,
        **options
    end

    def number_to_currency(*args)
      ActiveSupport::NumberHelper.number_to_currency(*args)
    end
  end
end
