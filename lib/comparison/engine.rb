module Comparison
  class Engine < ::Rails::Engine
    isolate_namespace Comparison

    initializer 'comparison.view_helpers' do
      ActionView::Base.send :include, helpers
    end
  end
end
