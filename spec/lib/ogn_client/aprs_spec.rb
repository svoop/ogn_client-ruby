require_relative '../../spec_helper'

describe OGNClient::APRS do

  describe "#new" do
    it "must choose the correct port" do
      _(OGNClient::APRS.new(callsign: "ROCT").instance_variable_get(:@port)).must_equal OGNClient::APRS::PORT_UNFILTERED
      _(OGNClient::APRS.new(callsign: "ROCT", filter: "p/oggy/ist/super").instance_variable_get(:@port)).must_equal OGNClient::APRS::PORT_FILTERED
    end
  end

  describe "#start" do
    it "must connect and parse 50 valid real-time raw messages" do
      OGNClient::APRS.start(callsign: "ROCT#{rand(1000)}") do |aprs|
        print '  parsing 50 real-time messages'
        50.times do
          print '.'
          OGNClient::Message.parse aprs.gets
        end
        puts
      end
    end
  end

  describe "#passcode" do
    subject { OGNClient::APRS.new callsign: "ROCT" }

    it "must return -1 for readonly logins" do
      _(subject.send(:passcode, readonly: true)).must_equal (-1)
    end

    it "must calculate the passcode for readwrite logins" do
      _(subject.send(:passcode, readonly: false)).must_equal 25337
    end
  end

  describe "#handshake without filters" do
    subject { OGNClient::APRS.new callsign: "ROCT" }

    it "must return a valid APRS handshake string for readonly logins" do
      _(subject.send(:handshake, readonly: true)).must_equal "user ROCT pass -1 vers #{OGNClient::APRS::AGENT} #{OGNClient::VERSION}"
    end

    it "must return a valid APRS handshake string for readwrite logins" do
      _(subject.send(:handshake, readonly: false)).must_equal "user ROCT pass 25337 vers #{OGNClient::APRS::AGENT} #{OGNClient::VERSION}"
    end
  end

  describe "#handshake with filters" do
    subject { OGNClient::APRS.new callsign: "ROCT", filter: "p/oggy/ist/super" }

    it "must return a valid APRS handshake string with filters" do
      _(subject.send(:handshake, readonly: true)).must_equal "user ROCT pass -1 vers #{OGNClient::APRS::AGENT} #{OGNClient::VERSION} filter p/oggy/ist/super"
    end
  end

end
