require_relative '../../../spec_helper'

describe OGNClient::ReceiverBeacon do

  it "must parse valid raw message" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::ReceiverBeacon
    subject.raw.must_equal raw
  end

end
