# frozen-string-literal: true

require 'delegate'
require 'forwardable'

module Comparison
  class Presenter < DelegateClass(Comparator)
    extend Forwardable
    include ActionView::Helpers::TranslationHelper

    ARROWS = { up: '&uarr;', down: '&darr;', none: '' }

    # TODO: This shouldn't necessarily return a currency representation.

    ##
    # Returns `Comparator#absolute` presented as currency.
    def difference(**options)
      if positive?
        number_to_currency absolute, format: '+%u%n', **options
      else
        number_to_currency absolute, **options
      end
    end

    ##
    # Returns `Comparator#relative` formatted as a percentage.
    #
    # If the relative percentage evaluates to Infinity or -Infinity, +nil+ is
    # returned. If it evaluates to NaN, 0 is returned.
    def percentage(delimiter: ',', precision: 0, **options)
      case
      when nan? || zero?
        number_to_percentage 0, precision: precision, **options
      when infinite?
        # TODO: Return nil, or lookup an optional representation in I18n?
        nil
      when positive?
        number_to_percentage relative, delimiter: delimiter,
          precision: precision, format: '+%n%', **options
      else
        number_to_percentage relative, delimiter: delimiter,
          precision: precision, **options
      end
    end

    alias_method :change, :percentage
    deprecate :change

    delegate %i[number_to_currency number_to_percentage] => :'ActiveSupport::NumberHelper'

    ##
    # Returns the I18n translation for `comparison.icons`. (See also `#arrow`.)
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
    # en:
    #   comparison:
    #     icons:
    #       positive_html: '<span class="glyphicon glyphicon-arrow-up"></span>'
    #       negative_html: '<span class="glyphicon glyphicon-arrow-down"></span>'
    #       nochange_html: '<span class="glyphicon glyphicon-minus"></span>'
    def icon
      case
      when positive?
        t 'comparison.icons.positive_html'
      when negative?
        t 'comparison.icons.negative_html'
      else
        t 'comparison.icons.nochange_html'
      end
    end

    ##
    # Returns the I18n translation for `comparison.icons`. (See also `#icon`.)
    #
    # This method is intended to display a graphical representation of the
    # comparison. Typically this would be an arrow pointing up or down.
    #
    # The default implementation is as follows:
    #
    # en:
    #   comparison:
    #     arrows:
    #       positive_html: '&uarr;'
    #       negative_html: '&darr;'
    #       nochange_html: ''
    #
    # For example, to generate up and down arrows using Glyphicons included
    # with Bootstrap, you could add the following translations to your
    # application:
    #
    # `#arrows` and its sister method `#icon` perform roughly identical tasks
    # with roughly identical intentions. The difference between the two methods
    # is in the context in which they are intended to be used.
    #
    # `#arrows` is meant to be used from view contexts with limited
    # functionality such as an HTML email. As such, the translations you
    # specify should be simple enough, like HTML character entities, to work
    # within said view context.
    #
    # `#icons` is meant to be used from full-featured view contexts. As such,
    # `#icons` is the one to use to generate HTML tags.
    def arrow
      case
      when positive?
        t 'comparison.arrows.positive_html', default: ARROWS[:up]
      when negative?
        t 'comparison.arrows.negative_html', default: ARROWS[:down]
      else
        t 'comparison.arrows.nochange_html', default: ARROWS[:none]
      end
    end

    ##
    # Returns the I18n translation for `comparison.classes`. (See also `#css`.)
    #
    # Use these translations to specify CSS classes for tags that contain
    # comparison data. For example:
    #
    # en:
    #   comparison:
    #     classes:
    #       positive: 'comparison positive'
    #       negative: 'comparison negative'
    #       nochange: 'comparison nochange'
    #
    # .comparison.positive {
    #   color: #3c763d;
    #   background-color: #dff0d8;
    # }
    # .comparison.negative {
    #   color: #a94442;
    #   background-color: #f2dede;
    # }
    # .comparison.nochange {
    #   color: #777777;
    # }
    #
    # content_tag cmp.difference, class: cmp.classes
    def classes
      case
      when positive?
        t 'comparison.classes.positive'
      when negative?
        t 'comparison.classes.negative'
      else
        t 'comparison.classes.nochange'
      end
    end

    ##
    # Returns the I18n translation for `comparison.css`. (See also `#classes`.)
    #
    # Use these translations to specify raw CSS style rules to be used when
    # formatting comparison data. For example:
    #
    # en:
    #   comparison:
    #     css:
    #       positive: 'color: #3c763d; background-color: #dff0d8;'
    #       negative: 'color: #a94442; background-color: #f2dede;'
    #       nochange: 'color: #777777;'
    #
    # content_tag cmp.difference, style: cmp.css
    #
    # `#css` and its sister method `#classes` perform very similar tasks. Use
    # `#css` when you need to embed the CSS style rules in an HTML tag using
    # the style attribute. Use `#classes` when you want have the CSS style
    # rules defined in a class and want to add that class to the HTML tag.
    def css
      case
      when positive?
        t 'comparison.css.positive', default: ''
      when negative?
        t 'comparison.css.negative', default: ''
      else
        t 'comparison.css.nochange', default: ''
      end
    end

    alias_method :style, :css
  end
end
