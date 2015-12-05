gem 'minitest'

require 'pathname'

require 'minitest/autorun'
require 'minitest/reporters'

require 'minitest/matchers'
# require 'mocha/mini_test'

begin; require 'minitest/osx'; rescue LoadError; end

MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new

require Pathname(__dir__).join('..', 'lib', 'ogn_client')
# require Pathname(__dir__).join('initializer')
# require Pathname(__dir__).join('factories')

class MiniTest::Spec
  class << self
    alias_method :context, :describe
  end
end
