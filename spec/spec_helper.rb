gem 'minitest'

require 'pathname'

require 'minitest/autorun'
require Pathname(__dir__).join('..', 'lib', 'ogn_client')

require 'minitest/flash'

Minitest.load_plugins

class Minitest::Spec
  class << self
    alias_method :context, :describe
  end
end
