gem 'minitest'

require 'pathname'

require 'minitest/autorun'
require Pathname(__dir__).join('..', 'lib', 'ogn_client')

require 'minitest/sound'
require 'minitest/sound/reporter'
Minitest::Sound.success = Pathname(__dir__).join('sounds/success.mp3').to_s
Minitest::Sound.failure = Pathname(__dir__).join('sounds/failure.mp3').to_s
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, Minitest::Sound::Reporter.new]

require 'minitest/matchers'

class MiniTest::Spec
  class << self
    alias_method :context, :describe
  end
end
