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
        nil
      when positive?
        number_to_percentage relative, delimiter: delimiter,
          precision: precision, format: '+%n%', **options
      else
        number_to_percentage relative, delimiter: delimiter,
          precision: precision, **options
      end
    end

    delegate %i[number_to_currency number_to_percentage] => :'ActiveSupport::NumberHelper'

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

    # TODO: #icon
    # The #arrow method generates simple HTML character entities suitable for
    # limited funcationality views like HTML email. The #icon method will
    # return more complex graphical arrow suitable for first-class browser
    # views.

    # TODO: #css
    # The #css method will generate CSS styles that can be passed to the style
    # attribute of a tag, suitable for limited functionality views such as HTML
    # email.
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
  end
end
