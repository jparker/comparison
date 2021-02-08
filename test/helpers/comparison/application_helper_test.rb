# frozen-string-literal: true

require 'test_helper'

module Comparison
  class ApplicationHelperTest < ActionView::TestCase
    test 'compare yields a comparison presenter' do
      compare 100, 75 do |cmp|
        assert_equal '+33%', cmp.percentage
        return
      end
      flunk 'block was not executed'
    end

    test 'compare returns a comparison presenter' do
      cmp = compare 100, 75
      assert_equal '+33%', cmp.percentage
    end
  end
end
