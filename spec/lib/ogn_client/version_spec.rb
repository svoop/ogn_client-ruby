require_relative '../../spec_helper'

describe "OGNClient::VERSION" do

  it "must be defined" do
    OGNClient::VERSION.wont_be_nil
  end

end
