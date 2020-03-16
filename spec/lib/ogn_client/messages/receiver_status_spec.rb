require_relative '../../../spec_helper'

describe OGNClient::ReceiverStatus do

  it "must parse valid raw message" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h v0.2.6.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm 4.902V 0.583A +33.6C 14/16Acfts[1h] RF:+62-0.8ppm/+33.66dB/+19.4dB@10km[112619]/+25.0dB@10km[8/15]"
    subject = OGNClient::Message.parse raw
    _(subject).must_be_instance_of OGNClient::ReceiverStatus
    _(subject.raw).must_equal raw
    _(subject.version).must_equal '0.2.6'
    _(subject.platform).must_equal :arm
    _(subject.cpu_load).must_equal 0.2
    _(subject.cpu_temperature).must_equal 33.6
    _(subject.voltage).must_equal 4.902
    _(subject.amperage).must_equal 0.583
    _(subject.senders).must_equal 16
    _(subject.visible_senders).must_equal 14
    _(subject.invisible_senders).must_equal 2
    _(subject.ram_free).must_equal 777.7
    _(subject.ram_total).must_equal 972.2
    _(subject.ntp_offset).must_equal 3.1
    _(subject.ntp_correction).must_equal (-3.8)
    _(subject.rf_correction_manual).must_equal 62
    _(subject.rf_correction_automatic).must_equal (-0.8)
    _(subject.signal_quality).must_equal 33.66
    _(subject.senders_signal_quality).must_equal 19.4
    _(subject.senders_messages).must_equal 112619
    _(subject.good_senders_signal_quality).must_equal 25
    _(subject.good_and_bad_senders).must_equal 15
    _(subject.good_senders).must_equal 8
    _(subject.bad_senders).must_equal 7
  end

  it "must parse valid raw message without version" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm 4.902V 0.583A +33.6C 14/16Acfts[1h] RF:+62-0.8ppm/+33.66dB/+19.4dB@10km[112619]/+25.0dB@10km[8/15]"
    subject = OGNClient::Message.parse raw
    _(subject).must_be_instance_of OGNClient::ReceiverStatus
    _(subject.version).must_be_nil
    _(subject.platform).must_be_nil
  end

  it "must parse valid raw message without platform" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h v0.2.6 CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm 4.902V 0.583A +33.6C 14/16Acfts[1h] RF:+62-0.8ppm/+33.66dB/+19.4dB@10km[112619]/+25.0dB@10km[8/15]"
    subject = OGNClient::Message.parse raw
    _(subject).must_be_instance_of OGNClient::ReceiverStatus
    _(subject.platform).must_be_nil
  end

  it "must parse valid raw message without voltage" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h v0.2.6.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm 0.583A +33.6C 14/16Acfts[1h] RF:+62-0.8ppm/+33.66dB/+19.4dB@10km[112619]/+25.0dB@10km[8/15]"
    subject = OGNClient::Message.parse raw
    _(subject).must_be_instance_of OGNClient::ReceiverStatus
    _(subject.voltage).must_be_nil
  end

  it "must parse valid raw message without amperage" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h v0.2.6.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm 4.902V +33.6C 14/16Acfts[1h] RF:+62-0.8ppm/+33.66dB/+19.4dB@10km[112619]/+25.0dB@10km[8/15]"
    subject = OGNClient::Message.parse raw
    _(subject).must_be_instance_of OGNClient::ReceiverStatus
    _(subject.amperage).must_be_nil
  end

  it "must parse valid raw message without temperature" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h v0.2.6.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm 4.902V 0.583A 14/16Acfts[1h] RF:+62-0.8ppm/+33.66dB/+19.4dB@10km[112619]/+25.0dB@10km[8/15]"
    subject = OGNClient::Message.parse raw
    _(subject).must_be_instance_of OGNClient::ReceiverStatus
    _(subject.cpu_temperature).must_be_nil
  end

  it "must parse valid raw message without senders" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h v0.2.6.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm 4.902V 0.583A +33.6C RF:+62-0.8ppm/+33.66dB/+19.4dB@10km[112619]/+25.0dB@10km[8/15]"
    subject = OGNClient::Message.parse raw
    _(subject).must_be_instance_of OGNClient::ReceiverStatus
    _(subject.visible_senders).must_be_nil
    _(subject.invisible_senders).must_be_nil
  end

  it "must parse valid raw message without signal_quality, corrections nor averages" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h v0.2.6.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm 4.902V 0.583A +33.6C 14/16Acfts[1h]"
    subject = OGNClient::Message.parse raw
    _(subject).must_be_instance_of OGNClient::ReceiverStatus
    _(subject.rf_correction_manual).must_be_nil
    _(subject.rf_correction_automatic).must_be_nil
    _(subject.signal_quality).must_be_nil
    _(subject.senders_signal_quality).must_be_nil
    _(subject.senders_messages).must_be_nil
    _(subject.good_senders_signal_quality).must_be_nil
    _(subject.good_senders).must_be_nil
    _(subject.bad_senders).must_be_nil
  end

  it "must parse valid raw message without corrections nor averages" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h v0.2.6.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm 4.902V 0.583A +33.6C 14/16Acfts[1h] RF:+33.66dB"
    subject = OGNClient::Message.parse raw
    _(subject).must_be_instance_of OGNClient::ReceiverStatus
    _(subject.rf_correction_manual).must_be_nil
    _(subject.rf_correction_automatic).must_be_nil
    _(subject.signal_quality).must_equal 33.66
    _(subject.senders_signal_quality).must_be_nil
    _(subject.senders_messages).must_be_nil
    _(subject.good_senders_signal_quality).must_be_nil
    _(subject.good_senders).must_be_nil
    _(subject.bad_senders).must_be_nil
  end

  it "must parse valid raw message without averages" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h v0.2.6.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm 4.902V 0.583A +33.6C 14/16Acfts[1h] RF:+62-0.8ppm/+33.66dB"
    subject = OGNClient::Message.parse raw
    _(subject).must_be_instance_of OGNClient::ReceiverStatus
    _(subject.rf_correction_manual).must_equal 62
    _(subject.rf_correction_automatic).must_equal (-0.8)
    _(subject.signal_quality).must_equal 33.66
    _(subject.senders_signal_quality).must_be_nil
    _(subject.senders_messages).must_be_nil
    _(subject.good_senders_signal_quality).must_be_nil
    _(subject.good_senders).must_be_nil
    _(subject.bad_senders).must_be_nil
  end

  it "must raise error if the version is not accepted yet" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h v999.999.999.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm 4.902V 0.583A +33.6C 14/16Acfts[1h] RF:+62-0.8ppm/+33.66dB/+19.4dB@10km[112619]/+25.0dB@10km[8/15]"
    _{ OGNClient::Message.parse(raw) }.must_raise OGNClient::ReceiverError
  end

  it "must warn if the version is not supported yet" do
    raw = "LKHS>APRS,TCPIP*,qAC,GLIDERN2:/211635h v0.2.999.ARM CPU:0.2 RAM:777.7/972.2MB NTP:3.1ms/-3.8ppm 4.902V 0.583A +33.6C 14/16Acfts[1h] RF:+62-0.8ppm/+33.66dB/+19.4dB@10km[112619]/+25.0dB@10km[8/15]"
    _{ OGNClient::Message.parse(raw) }.must_output('', /receiver version `0.2.999'/)
  end

end
