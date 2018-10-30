# frozen-string-literal: true

$:.push File.expand_path('lib', __dir__)

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

  s.required_ruby_version = '>= 2.3'

  s.add_dependency 'rails', '>= 4.0', '< 6.0'

  s.add_development_dependency 'minitest-focus'
  s.add_development_dependency 'pry'
end
