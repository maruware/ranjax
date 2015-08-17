$:.unshift('lib')
require 'ranjax/version'

Gem::Specification.new do |spec|
  spec.name = 'ranjax'
  spec.version = Ranjax::VERSION
  spec.authors = ['maruware']
  spec.email = ['maruware@maruware.com']
  spec.summary = %q{Random japanese text generator}
  spec.description = %q{Random japanese text generator}
  spec.homepage = 'https://github.com/maruware/ranjax'
  spec.license = 'MIT'

  spec.required_ruby_version     = '>= 1.9'
  spec.files = `git ls-files`.split($/)
  spec.require_paths = ['lib']

  spec.add_dependency 'natto'
end
