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

end
