require_relative '../../../spec_helper'

describe OGNClient::Comment do

  subject { OGNClient::Comment.new }

  it "must parse valid raw message" do
    raw = "# aprsc 2.0.14-g28c5a6a 29 Jun 2014 07:46:15 GMT GLIDERN1 37.187.40.234:14580"
    subject.parse(raw).wont_be_nil
    subject.raw.must_equal raw
    subject.comment.must_equal raw[2..-1]
  end

  it "won't parse invalid raw message" do
    raw = "// aprsc 2.0.14-g28c5a6a 29 Jun 2014 07:46:15 GMT GLIDERN1 37.187.40.234:14580"
    subject.parse(raw).must_be_nil
  end

end
