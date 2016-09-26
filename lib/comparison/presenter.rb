require 'delegate'
require 'forwardable'

module Comparison
  class Presenter < DelegateClass(Comparator)
    extend Forwardable

    def percentage(delimiter: ',', precision: 0, **options)
      case
      when nan? || zero?
        number_to_percentage 0, precision: precision, **options
      when infinite?
        nil
      when positive?
        number_to_percentage change, delimiter: delimiter,
          precision: precision, format: '+%n%', **options
      else
        number_to_percentage change, delimiter: delimiter,
          precision: precision, **options
      end
    end

    delegate [:number_to_percentage] => :'ActiveSupport::NumberHelper'

    def arrow
      case
      when positive?
        '&uarr;'.html_safe
      when negative?
        '&darr;'.html_safe
      else
        nil
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
  end
end
