## Main

Nothing so far

## 0.3.0

### Changes
* Drop certs
* Add action for trusted release

## 0.2.6

### Changes
* Update Ruby to 3.4

## 0.2.5

### Changes
* Skip live tests by default
* Update certificate

## 0.2.4

### Additions
* Add ogn2geojson
* Sign gem and add checksums

## 0.2.3

### Additions
* Add support for explicit message date

### Fixes
* Fix ogn2kml for larger tracks

## 0.2.2

### Additions
* Add example executables
  * ognlogd
  * ogn2kml

## 0.2.0

### Additions
* Support for receiver versions <= 0.2.6
  * Renamed `Sender` to `SenderBeacon`
  * Devided `Receiver` to `ReceiverBeacon` and `ReceiverStatus`
  * `ReceiverStatus` is *not* available for receiver versions < 0.2.6

## 0.1.3

### Changes
* Renamed sender and receiver attributes
  * `Sender#signal` -> `Sender#signal_quality`
  * `Sender#power` -> `Sender#signal_power`
  * `Receiver#signal` -> `Receiver#signal_quality`
  * `Receiver#senders_signal` -> `Receiver#senders_signal_quality`
  * `Receiver#good_senders_signal` -> `Receiver#good_senders_signal_quality`

## 0.1.2

### Additions
* Support for receiver versions <= 0.2.5
* New sender and receiver attributes
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

### Changes
* Faster message parsing
* Renamed receiver attributes
  * `Receiver#manual_correction` -> `Receiver#rf_correction_manual`
  * `Receiver#automatic_correction` -> `Receiver#rf_correction_automatic`

## 0.1.1

### Additions
* New sender and receiver attributes
  * `Sender#flight_level
  * `Sender#flarm_software_version`
  * `Sender#flarm_hardware_version`
  * `Sender#flarm_id`
  * `Receiver#manual_correction`
  * `Receiver#automatic_correction`
* Verification of supported receiver version

### Changes
* Supported receiver versions <= 0.2.4
* Convert raw messages to UTF-8 before parsing
* Renamed message attribute
  * `Message#speed` -> `Message#ground_speed`

### Removals
* Remove debug support and raise errors instead

## 0.1.0

### Additions
* OGN subscription
* Parser for senders, receivers and comments with attributes
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
