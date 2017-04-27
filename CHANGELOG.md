## 0.2.1

  * add example executables
    * ognlogd
    * ogn2kml

## 0.2.0

  * support for receiver versions <= 0.2.6
    * renamed `Sender` to `SenderBeacon`
    * devided `Receiver` to `ReceiverBeacon` and `ReceiverStatus`
    * `ReceiverStatus` is *not* available for receiver versions < 0.2.6

## 0.1.3

  * renamed sender and receiver attributes
    * `Sender#signal` -> `Sender#signal_quality`
    * `Sender#power` -> `Sender#signal_power`
    * `Receiver#signal` -> `Receiver#signal_quality`
    * `Receiver#senders_signal` -> `Receiver#senders_signal_quality`
    * `Receiver#good_senders_signal` -> `Receiver#good_senders_signal_quality`

## 0.1.2

  * support for receiver versions <= 0.2.5
  * faster message parsing
  * new sender and receiver attributes
    * `Sender#power`
    * `Receiver#voltage`
    * `Receiver#amperage`
    * `Receiver#senders`
    * `Receiver#senders_visible`
    * `Receiver#senders_invisible`
    * `Receiver#voltage`
    * `Receiver#senders_signal`
    * `Receiver#senders_messages`
    * `Receiver#good_and_bad_senders`
    * `Receiver#good_senders`
    * `Receiver#bad_senders`
  * renamed receiver attributes
    * `Receiver#manual_correction` -> `Receiver#rf_correction_manual`
    * `Receiver#automatic_correction` -> `Receiver#rf_correction_automatic`

## 0.1.1

  * supported receiver versions <= 0.2.4
  * remove debug support and raise errors instead
  * convert raw messages to UTF-8 before parsing
  * new sender and receiver attributes
    * `Sender#flight_level
    * `Sender#flarm_software_version`
    * `Sender#flarm_hardware_version`
    * `Sender#flarm_id`
    * `Receiver#manual_correction`
    * `Receiver#automatic_correction`
  * renamed message attribute
    * `Message#speed` -> `Message#ground_speed`
  * verification of supported receiver version

## 0.1.0

  * OGN subscription
  * parser for senders, receivers and comments with attributes
    * `Message#raw`
    * `Message#callsign`
    * `Message#receiver`
    * `Message#time`
    * `Message#longitude`
    * `Message#latitude`
    * `Message#altitude`
    * `Message#heading`
    * `Message#speed`
    * `Sender#stealth_mode`
    * `Sender#no_tracking`
    * `Sender#sender_type`
    * `Sender#address_type`
    * `Sender#id`
    * `Sender#climb_rate`
    * `Sender#turn_rate`
    * `Sender#signal`
    * `Sender#errors`
    * `Sender#frequency_offset`
    * `Sender#gps_accuracy`
    * `Sender#proximity`
    * `Receiver#version`
    * `Receiver#platform`
    * `Receiver#cpu_load`
    * `Receiver#cpu_temperature`
    * `Receiver#ram_free`
    * `Receiver#ram_total`
    * `Receiver#ntp_offset`
    * `Receiver#ntp_correction`
    * `Receiver#signal`
    * `Comment#comment`
