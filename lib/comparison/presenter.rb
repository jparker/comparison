# frozen-string-literal: true

require 'delegate'
require 'forwardable'

module Comparison
  class Presenter < DelegateClass(Comparator)
    extend Forwardable
    include ActionView::Helpers::TranslationHelper

    ARROWS = { up: '&uarr;', down: '&darr;', none: '' }

    # TODO: This shouldn't necessarily return a currency representation.
    def difference(**options)
      if positive?
        number_to_currency absolute, format: '+%u%n', **options
      else
        number_to_currency absolute, **options
      end
    end

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
