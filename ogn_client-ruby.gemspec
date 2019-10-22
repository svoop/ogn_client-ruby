# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ogn_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'ogn_client-ruby'
  spec.version       = OGNClient::VERSION
  spec.authors       = ['Sven Schwyn']
  spec.email         = ['ruby@bitcetera.com']
  spec.summary       = %q{Subscriber and parser for APRS messages from OGN}
  spec.description   = %q{OGN (glidernet.org) broadcasts aircraft positions as APRS/APRS-IS messages. This gem hooks into this stream of data and provides the necessary classes to parse the raw message strings into meaningful objects.}
  spec.homepage      = 'https://github.com/svoop/ogn_client-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'minitest-sound'
  spec.add_development_dependency 'minitest-matchers'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
end
