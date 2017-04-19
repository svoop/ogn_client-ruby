require_relative '../../spec_helper'

describe OGNClient::Message do

  it "must parse valid raw message" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    def Time.now; Time.new(2012, 12, 12, 22, 01, 37, 0); end
    subject = OGNClient::Message.parse raw
    subject.raw.must_equal raw
    subject.callsign.must_equal "FLRDF0A52"
    subject.receiver.must_equal "LSTB"
    subject.time.must_equal Time.new(2012, 12, 12, 22, 01, 32, 0)
    subject.longitude.must_equal 7.128783
    subject.latitude.must_equal 46.978383
    subject.altitude.must_equal 434
    subject.heading.must_equal 90
    subject.ground_speed.must_equal 100
  end

  it "must parse 5000 recorded valid real-world raw messages" do
    fixtures_file = 'spec/fixtures/messages.txt'
    unless File.exist? fixtures_file
      File.open(fixtures_file, 'w') do |file|
        OGNClient::APRS.start(callsign: "ROCT#{rand(1000)}") do |aprs|
          print '  recording 5000 real-time messages'
          5000.times do
            print '.'
            file.puts aprs.gets
          end
          puts
        end
      end
    end
    File.foreach(fixtures_file) do |raw|
      OGNClient::Message.parse raw
    end
  end

  it "must parse valid raw message around midnight" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/235955h4658.70N/00707.72Ez090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    def Time.now; Time.new(2012, 12, 12, 00, 00, 05, 0); end
    subject = OGNClient::Message.parse raw
    subject.time.must_equal Time.new(2012, 12, 11, 23, 59, 55, 0)
  end

  it 'must parse valid raw message without longitude nor latitude' do
    raw = "FLRDF0A52>APRS,qAS,LSTB:>220132h090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.longitude.must_be_nil
    subject.latitude.must_be_nil
  end

  it 'must parse valid raw message without heading nor ground speed' do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez/A=001424 id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.heading.must_be_nil
    subject.ground_speed.must_be_nil
  end

  it 'must parse valid raw message without altitude' do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054 !W37! id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.altitude.must_be_nil
  end

  it 'must parse valid raw message with "no data" heading and ground speed' do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez000/000/A=001424 id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.heading.must_be_nil
    subject.ground_speed.must_be_nil
  end

  it "must parse valid raw message without longitude/latitude enhancement" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    subject = OGNClient::Message.parse raw
    subject.longitude.must_equal 7.128667
    subject.latitude.must_equal 46.978333
  end

  it "must raise error for raw message class other than String" do
    raw = nil
    -> { OGNClient::Message.parse(raw) }.must_raise OGNClient::MessageError
  end

  it "must raise error for message which payload cannot be parsed" do
    raw = "FLRDF0A52"
    -> { OGNClient::Message.parse(raw) }.must_raise OGNClient::MessageError
  end

  it "must raise error for message which position cannot be parsed" do
    raw = "FLRDF0A52>APRS,qAS,LSTB:/220132hXXX/XXXz090/054/A=001424 !W37! id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz gps4x6 hearD7EA hearDA95"
    -> { OGNClient::Message.parse(raw) }.must_raise OGNClient::MessageError
  end

end
