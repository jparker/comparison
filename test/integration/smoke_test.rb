# frozen-string-literal: true

require 'test_helper'

class SmokeTest < ActionDispatch::IntegrationTest
  # I am not sure why Rubocop is raising an AbcSize complaint below. I suspect
  # it is not handling the nested assert_selects intelligently. I don't see a
  # better way to write this test without being unnecessarily redudant.

  test 'comparison smoke test' do
    get root_path

    assert_select 'tr:nth-child(1)' do
      assert_select 'td:nth-child(1)', '-$25.00'
      assert_select 'td:nth-child(2)', '-25%'
      assert_select 'td:nth-child(3)', "\u2193"
    end

    assert_select 'tr:nth-child(2)' do
      assert_select 'td:nth-child(1)', '+$25.00'
      assert_select 'td:nth-child(2)', '+33%'
      assert_select 'td:nth-child(3)', "\u2191"
    end

    assert_select 'tr:nth-child(3)' do
      assert_select 'td:nth-child(1)', '$0.00'
      assert_select 'td:nth-child(2)', '0%'
      assert_select 'td:nth-child(3)',
        'NC (overridden in test/dummy/config/locales/en.yml)'
    end

    assert_select 'tr:nth-child(4)' do
      assert_select 'td:nth-child(1)', '+$75.00'
      assert_select 'td:nth-child(2)', "\u2014"
      assert_select 'td:nth-child(3)', "\u2191"
    end
  end
end
