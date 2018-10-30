# frozen-string-literal: true

module Comparison
  class Engine < ::Rails::Engine # :nodoc:
    isolate_namespace Comparison

    initializer 'comparison.view_helpers' do
      ActionView::Base.send :include, helpers
    end
  end
end
