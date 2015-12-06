require_relative '../../spec_helper'

describe OGNClient::Message do

  subject { OGNClient::Message.new }

  it "must parse valid raw message" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    def Time.now; Time.new(2012, 12, 12, 22, 01, 37, 0); end
    subject.parse(raw).wont_be_nil
    subject.raw.must_equal raw
    subject.callsign.must_equal "FLRDF0A52"
    subject.receiver.must_equal "LSTB"
    subject.time.must_equal Time.new(2012, 12, 12, 22, 01, 32, 0)
    subject.longitude.must_equal 7.128783
    subject.latitude.must_equal 46.978383
    subject.altitude.must_equal 434
    subject.heading.must_equal 90
    subject.speed.must_equal 100
  end

  it "must parse valid raw message around midnight" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/235955h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    def Time.now; Time.new(2012, 12, 12, 00, 00, 05, 0); end
    subject.parse(raw).wont_be_nil
    subject.time.must_equal Time.new(2012, 12, 11, 23, 59, 55, 0)
  end

  it "must parse valid raw message without longitude/latitude enhancement" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    subject.parse(raw).wont_be_nil
    subject.longitude.must_equal 7.128667
    subject.latitude.must_equal 46.978333
  end

  it 'must parse valid raw message without heading and speed' do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez/A=001424 id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    subject.parse(raw).wont_be_nil
    subject.heading.must_be_nil
    subject.speed.must_be_nil
  end

  it 'must parse valid raw message with "no data" heading and speed' do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez000/000/A=001424 id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    subject.parse(raw).wont_be_nil
    subject.heading.must_be_nil
    subject.speed.must_be_nil
  end

  it "must parse invalid raw message but issue a debug warning" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70/00707.72z090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    old_debug, old_stdout = $DEBUG, $stdout
    begin
      $DEBUG, $stdout = true, StringIO.new('', 'w')
      subject.parse(raw).wont_be_nil
      subject.raw.must_equal raw
      $stdout.string.wont_equal ''
    ensure
      $DEBUG, $stdout = old_debug, old_stdout
    end
  end

end
