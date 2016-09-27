require 'test_helper'

class SmokeTest < ActionDispatch::IntegrationTest
  def test_comparison
    get root_path

    assert_select 'tr:nth-child(1)' do
      assert_select 'td:nth-child(1)', '-$25.00'
      assert_select 'td:nth-child(2)', '-25%'
      assert_select 'td:nth-child(3)', '↓'
    end

    assert_select 'tr:nth-child(2)' do
      assert_select 'td:nth-child(1)', '+$25.00'
      assert_select 'td:nth-child(2)', '+33%'
      assert_select 'td:nth-child(3)', '↑'
    end

    assert_select 'tr:nth-child(3)' do
      assert_select 'td:nth-child(1)', '$0.00'
      assert_select 'td:nth-child(2)', '0%'
      assert_select 'td:nth-child(3)', ''
    end

    assert_select 'tr:nth-child(4)' do
      assert_select 'td:nth-child(1)', '+$75.00'
      assert_select 'td:nth-child(2)', '—'
      assert_select 'td:nth-child(3)', '↑'
    end
  end
end

