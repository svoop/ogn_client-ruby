require_relative '../../../spec_helper'

describe OGNClient::Sender do

  it "must parse valid raw message" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot FL001.03 55.2dB 0e -6.2kHz gps4x6 s6.01 h03 rDDACC4 +5.0dBm hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Sender
    subject.raw.must_equal raw
    subject.stealth_mode.must_equal false
    subject.no_tracking.must_equal false
    subject.sender_type.must_equal :glider
    subject.address_type.must_equal :flarm
    subject.id.must_equal "DF0A52"
    subject.climb_rate.must_equal 0.1
    subject.turn_rate.must_equal 0.0
    subject.flight_level.must_equal 1.03
    subject.signal.must_equal 55.2
    subject.errors.must_equal 0
    subject.frequency_offset.must_equal -6.2
    subject.gps_accuracy.must_equal [4, 6]
    subject.flarm_software_version.must_equal Gem::Version.new('6.01')
    subject.flarm_hardware_version.must_equal Gem::Version.new(0x03)
    subject.flarm_id.must_equal 'DDACC4'
    subject.power.must_equal 5.0
    subject.proximity.must_equal ["D7EA", "DA95"]
  end

  it "must parse valid raw message without flight level" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 s6.01 h03 rDDACC4 +5.0dBm hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Sender
    subject.flight_level.must_be_nil
  end

  it "must parse valid raw message without gps" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot FL001.03 55.2dB 0e -6.2kHz s6.01 h03 rDDACC4 +5.0dBm hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Sender
    subject.gps_accuracy.must_be_nil
  end

  it "must parse valid raw message without FLARM software version" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot FL001.03 55.2dB 0e -6.2kHz gps4x6 h03 rDDACC4 +5.0dBm hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Sender
    subject.flarm_software_version.must_be_nil
  end

  it "must parse valid raw message without FLARM hardware version" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot FL001.03 55.2dB 0e -6.2kHz gps4x6 s6.01 rDDACC4 +5.0dBm hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Sender
    subject.flarm_hardware_version.must_be_nil
  end

  it "must parse valid raw message of address type FLARM device without explicit FLARM ID" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot FL001.03 55.2dB 0e -6.2kHz gps4x6 s6.01 h03 +5.0dBm hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Sender
    subject.id.must_equal "DF0A52"
    subject.flarm_id.must_equal subject.id
  end

  it "must parse valid raw message of address type ICOA without explicit FLARM ID" do
    raw = "ICA4B43D6>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id0D4B43D6 +020fpm +0.0rot FL001.03 55.2dB 0e -6.2kHz gps4x6 s6.01 h03 +5.0dBm hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Sender
    subject.id.must_equal "4B43D6"
    subject.flarm_id.must_equal subject.id
  end

  it "must parse valid raw message of address type FLARM without explicit FLARM ID" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot FL001.03 55.2dB 0e -6.2kHz gps4x6 s6.01 h03 +5.0dBm hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Sender
    subject.id.must_equal "DF0A52"
    subject.flarm_id.must_equal subject.id
  end

  it "must parse valid raw message of address type non-ICAO/FLARM without explicit FLARM ID" do
    raw = "OGN36581B>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id0736581B +020fpm +0.0rot FL001.03 55.2dB 0e -6.2kHz gps4x6 s6.01 h03 +5.0dBm hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Sender
    subject.id.must_equal "36581B"
    subject.flarm_id.must_be_nil
  end

  it "must parse valid raw message without power" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot FL001.03 55.2dB 0e -6.2kHz gps4x6 s6.01 h03 rDDACC4 hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Sender
    subject.power.must_be_nil
  end

  it "must parse valid raw message without proximity" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot FL001.03 55.2dB 0e -6.2kHz gps4x6 s6.01 h03 rDDACC4 +5.0dBm"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Sender
    subject.proximity.must_be_nil
  end

end
