require_relative '../../spec_helper'

describe OGNClient::APRS do

  describe "#new" do
    it "must choose the correct port" do
      OGNClient::APRS.new(callsign: "ROCT").instance_variable_get(:@port).must_equal OGNClient::APRS::PORT_UNFILTERED
      OGNClient::APRS.new(callsign: "ROCT", filter: "p/oggy/ist/super").instance_variable_get(:@port).must_equal OGNClient::APRS::PORT_FILTERED
    end
  end

  describe "#start" do
    it "must connect and parse 10 real-time messages" do
      OGNClient::APRS.start(callsign: "ROCT-#{rand(100)}") do |aprs|
        puts "  testing against 10 real-time messages"
        10.times do
          raw = aprs.gets
          puts "    #{raw}"
          message = OGNClient::Message.parse(raw)
          message.wont_be_nil
          message.wont_be_instance_of OGNClient::Message
        end
      end
    end
  end

  describe "#passcode" do
    subject { OGNClient::APRS.new callsign: "ROCT" }

    it "must return -1 for readonly logins" do
      subject.send(:passcode, readonly: true).must_equal -1
    end

    it "must calculate the passcode for readwrite logins" do
      subject.send(:passcode, readonly: false).must_equal 25337
    end
  end

  describe "#handshake without filters" do
    subject { OGNClient::APRS.new callsign: "ROCT" }

    it "must return a valid APRS handshake string for readonly logins" do
      subject.send(:handshake, readonly: true).must_equal "user ROCT pass -1 vers #{OGNClient::APRS::AGENT} #{OGNClient::VERSION}"
    end

    it "must return a valid APRS handshake string for readwrite logins" do
      subject.send(:handshake, readonly: false).must_equal "user ROCT pass 25337 vers #{OGNClient::APRS::AGENT} #{OGNClient::VERSION}"
    end
  end

  describe "#handshake with filters" do
    subject { OGNClient::APRS.new callsign: "ROCT", filter: "p/oggy/ist/super" }

    it "must return a valid APRS handshake string with filters" do
      subject.send(:handshake, readonly: true).must_equal "user ROCT pass -1 vers #{OGNClient::APRS::AGENT} #{OGNClient::VERSION} filter p/oggy/ist/super"
    end
  end

end
