## 0.1.1

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
  * supported receiver versions <= 0.2.5

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
