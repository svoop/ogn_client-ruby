require_relative '../../../spec_helper'

describe OGNClient::Comment do

  it "must parse valid raw message" do
    raw = "# aprsc 2.0.14-g28c5a6a 29 Jun 2014 07:46:15 GMT GLIDERN1 37.187.40.234:14580"
    subject = OGNClient::Message.parse raw
    _(subject).must_be_instance_of OGNClient::Comment
    _(subject.raw).must_equal raw
    _(subject.comment).must_equal raw[2..-1]
  end

end
