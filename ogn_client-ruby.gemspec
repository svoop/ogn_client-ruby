# coding: utf-8
require_relative 'lib/ogn_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'ogn_client-ruby'
  spec.version       = OGNClient::VERSION
  spec.summary       = 'Subscriber and parser for APRS messages from OGN'
  spec.description   = <<~END
    OGN (glidernet.org) broadcasts aircraft positions as APRS/APRS-IS messages.
    This gem hooks into this stream of data and provides the necessary classes
    to parse the raw message strings into meaningful objects.
  END
  spec.authors       = ['Sven Schwyn']
  spec.email         = ['ruby@bitcetera.com']
  spec.homepage      = 'https://github.com/svoop/ogn_client-ruby'
  spec.license       = 'MIT'

  spec.metadata = {
    'homepage_uri'      => spec.homepage,
    'changelog_uri'     => 'https://github.com/svoop/ogn_client-ruby/blob/master/CHANGELOG.md',
    'source_code_uri'   => 'https://github.com/svoop/ogn_client-ruby',
    'documentation_uri' => 'https://www.rubydoc.info/gems/ogn_client-ruby',
    'bug_tracker_uri'   => 'https://github.com/svoop/ogn_client-ruby/issues'
  }

  spec.files         = Dir['lib/**/*']
  spec.require_paths = %w(lib)
  spec.bindir        = 'exe'
  spec.executables   = %w(ogn2geojson ogn2kml ognlogd)

  spec.extra_rdoc_files = Dir['README.md', 'CHANGELOG.md', 'LICENSE.txt']
  spec.rdoc_options    += [
    '--title', 'OGN Subscriber and Parser',
    '--main', 'README.md',
    '--line-numbers',
    '--inline-source',
    '--quiet'
  ]

  spec.required_ruby_version = '>= 2.4.0'

  spec.add_dependency 'ostruct'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-flash'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
end
