require_relative '../../../spec_helper'

describe OGNClient::Receiver do

  it "must parse valid raw message" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689 v0.2.4.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm +33.6C RF:+62-0.8ppm/+33.66dB"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Receiver
    subject.raw.must_equal raw
    subject.version.must_equal Gem::Version.new('0.2.4')
    subject.platform.must_equal :arm
    subject.cpu_load.must_equal 0.2
    subject.cpu_temperature.must_equal 33.6
    subject.ram_free.must_equal 777.7
    subject.ram_total.must_equal 972.2
    subject.ntp_offset.must_equal 3.1
    subject.ntp_correction.must_equal -3.8
    subject.manual_correction.must_equal 62
    subject.automatic_correction.must_equal -0.8
    subject.signal.must_equal 33.66
  end

  it "must parse valid raw message without version" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689 CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm +33.6C RF:+62-0.8ppm/+33.66dB"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Receiver
    subject.version.must_be_nil
    subject.platform.must_be_nil
  end

  it "must parse valid raw message without platform" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689 v0.2.4 CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm +33.6C RF:+62-0.8ppm/+33.66dB"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Receiver
    subject.platform.must_be_nil
  end

  it "must parse valid raw message without temperature" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689 v0.2.4.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm RF:+62-0.8ppm/+33.66dB"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Receiver
    subject.cpu_temperature.must_be_nil
  end

  it "must parse valid raw message without signal and corrections" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689 v0.2.4.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm +33.6C"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Receiver
    subject.manual_correction.must_be_nil
    subject.automatic_correction.must_be_nil
    subject.signal.must_be_nil
  end

  it "must parse valid raw message without corrections" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689 v0.2.4.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm +33.6C RF:+33.66dB"
    subject = OGNClient::Message.parse raw
    subject.must_be_instance_of OGNClient::Receiver
    subject.manual_correction.must_be_nil
    subject.automatic_correction.must_be_nil
    subject.signal.must_equal 33.66
  end

  it "must raise error if the version is not supported yet" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h4902.45NI01429.51E&000/000/A=001689 v999.999.999.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm +33.6C RF:+62-0.8ppm/+33.66dB"
    -> { OGNClient::Message.parse(raw) }.must_raise OGNClient::ReceiverError
  end

end
