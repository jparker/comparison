require 'delegate'

class Comparison
  class Presenter < DelegateClass(Comparison)
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

    delegate :number_to_percentage, to: :'ActiveSupport::NumberHelper'

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
  end
end
