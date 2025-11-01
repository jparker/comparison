# frozen-string-literal: true

$LOAD_PATH.push File.expand_path 'lib', __dir__

# Maintain your gem's version:
require 'comparison/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comparison'
  s.version     = Comparison::VERSION
  s.authors     = ['John Parker']
  s.email       = ['jparker@urgetopunt.com']
  s.homepage    = 'https://github.com/jparker/comparison'
  s.summary     = 'Helpers for displaying details of comparing two numbers.'
  s.description = 'Helpers for displaying details of comparing two numbers.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'rails', '>= 5.0', '< 9.0'

  s.add_development_dependency 'mocha'
  s.add_development_dependency 'debug'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'minitest-focus'
end
