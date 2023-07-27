gem 'minitest'

require 'pathname'

require 'minitest/autorun'
require Pathname(__dir__).join('..', 'lib', 'ogn_client')

require 'minitest/sound'
Minitest::Sound.success = Pathname(__dir__).join('sounds', 'success.mp3').to_s
Minitest::Sound.failure = Pathname(__dir__).join('sounds', 'failure.mp3').to_s

require 'minitest/focus'

class Minitest::Spec
  class << self
    alias_method :context, :describe
  end
end
