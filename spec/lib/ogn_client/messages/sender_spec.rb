require_relative '../../../spec_helper'

describe OGNClient::Sender do

  subject { OGNClient::Sender.new }

  it "must parse valid raw message" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    subject.parse(raw).wont_be_nil
    subject.raw.must_equal raw
    subject.stealth_mode.must_equal false
    subject.no_tracking.must_equal false
    subject.sender_type.must_equal :glider
    subject.address_type.must_equal :flarm
    subject.id.must_equal "DF0A52"
    subject.climb_rate.must_equal 0.1
    subject.turn_rate.must_equal 0.0
    subject.signal.must_equal 55.2
    subject.errors.must_equal 0
    subject.frequency_offset.must_equal -6.2
    subject.gps_accuracy.must_equal [4, 6]
    subject.proximity.must_equal ["D7EA", "DA95"]
  end

  it "must parse valid raw message without gps" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz hearD7EA hearDA95"
    subject.parse(raw).wont_be_nil
    subject.gps_accuracy.must_be_nil
  end

  it "must parse valid raw message without proximity" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6"
    subject.parse(raw).wont_be_nil
    subject.proximity.must_be_nil
  end

  it "won't parse invalid raw message" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    subject.parse(raw).must_be_nil
  end

end
