require_relative '../../spec_helper'

describe OGNClient do

  describe "#debug" do
    it "must print debug info according to the value of $DEBUG" do
      old_debug, old_stdout = $DEBUG, $stdout
      begin
        $DEBUG, $stdout = true, StringIO.new('', 'w')
        OGNClient.debug("test 1")
        $stdout.string.must_equal "DEBUG: test 1\n"
        $DEBUG, $stdout = false, StringIO.new('', 'w')
        OGNClient.debug("test 2")
        $stdout.string.must_equal ""
      ensure
        $DEBUG, $stdout = old_debug, old_stdout
      end
    end
  end

  describe "#debug with block" do
    it "must print debug info if the condition in the block is met" do
      old_debug, old_stdout = $DEBUG, $stdout
      begin
        $DEBUG, $stdout = true, StringIO.new('', 'w')
        OGNClient.debug("test 1") { true }
        $stdout.string.must_equal "DEBUG: test 1\n"
        $DEBUG, $stdout = true, StringIO.new('', 'w')
        OGNClient.debug("test 2") { false }
        $stdout.string.must_equal ""
      ensure
        $DEBUG, $stdout = old_debug, old_stdout
      end
    end
  end

end
