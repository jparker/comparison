require 'test_helper'

class Comparison
  class ApplicationHelperTest < ActionView::TestCase
    def test_yields_a_comparison_presenter
      compare 100, 75 do |cmp|
        assert_equal '+33%', cmp.percentage
        return
      end
      flunk 'block was not executed'
    end

    def test_returns_a_comparison_presenter
      cmp = compare 100, 75
      assert_equal '+33%', cmp.percentage
    end
  end
end
