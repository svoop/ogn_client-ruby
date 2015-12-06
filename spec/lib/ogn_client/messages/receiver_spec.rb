require_relative '../../../spec_helper'

describe OGNClient::Receiver do

  subject { OGNClient::Receiver.new }

  it "must parse valid raw message" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689 v0.2.4.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm +33.6C RF:+33.66dB"
    subject.parse(raw).wont_be_nil
    subject.raw.must_equal raw
    subject.version.must_equal Gem::Version.new('0.2.4')
    subject.platform.must_equal :arm
    subject.cpu_load.must_equal 0.2
    subject.cpu_temperature.must_equal 33.6
    subject.ram_free.must_equal 777.7
    subject.ram_total.must_equal 972.2
    subject.ntp_offset.must_equal 3.1
    subject.ntp_correction.must_equal -3.8
    subject.signal.must_equal 33.66
  end

  it "must parse valid raw message without signal" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689 v0.2.4.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm +33.6C"
    subject.parse(raw).wont_be_nil
    subject.signal.must_be_nil
  end

  it "must parse valid raw message without temperature" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689 v0.2.4.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm RF:+33.66dB"
    subject.parse(raw).wont_be_nil
    subject.cpu_temperature.must_be_nil
  end

  it "won't parse invalid raw message" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689 CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm +33.6C RF:+33.66dB"
    subject.parse(raw).must_be_nil
  end

  it "must issue a debug warning if the version is not supported yet" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689 v999.999.999.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm +33.6C RF:+33.66dB"
    old_debug, old_stdout = $DEBUG, $stdout
    begin
      $DEBUG, $stdout = true, StringIO.new('', 'w')
      subject.parse(raw).wont_be_nil
      $stdout.string.wont_equal ''
    ensure
      $DEBUG, $stdout = old_debug, old_stdout
    end
  end

end
