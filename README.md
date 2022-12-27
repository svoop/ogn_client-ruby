[![Version](https://img.shields.io/gem/v/ogn_client-ruby.svg?style=flat)](https://rubygems.org/gems/ogn_client-ruby)
[![Tests](https://img.shields.io/github/actions/workflow/status/svoop/ogn_client-ruby/test.yml?style=flat&label=tests)](https://github.com/svoop/ogn_client-ruby/actions?workflow=Test)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/svoop/ogn_client-ruby.svg?style=flat)](https://codeclimate.com/github/svoop/ogn_client-ruby)
[![Donorbox](https://img.shields.io/badge/donate-on_donorbox-yellow.svg)](https://donorbox.org/bitcetera)

# ogn_client-ruby

[OGN](http://glidernet.org) broadcasts aircraft positions as [APRS](http://www.aprs.org)/[APRS-IS](http://www.aprs-is.net) messages. This gem hooks into this stream of data and provides the necessary classes to parse the raw message strings into meaningful objects.

* Homepage: https://github.com/svoop/ogn_client-ruby
* Author: [Sven Schwyn](http://bitcetera.com)

:loudspeaker: A word from the shameless commerce division: Looking for a freelance Ruby developer? Surf to http://bitcetera.com and contact Sven. Or [show your support with a donation](https://donorbox.org/bitcetera-ogn_client-ruby). Yes, we do sponsored features, too.

## Installation

### Security

This gem is [cryptographically signed](https://guides.rubygems.org/security/#using-gems) in order to assure it hasn't been tampered with. Unless already done, please add the author's public key as a trusted certificate now:

```
gem cert --add <(curl -Ls https://raw.github.com/svoop/ogn_client-ruby/master/certs/svoop.pem)
```

### Bundler

Add the following to the <tt>Gemfile</tt> or <tt>gems.rb</tt> of your [Bundler](https://bundler.io) powered Ruby project:

```ruby
gem 'ogn_client-ruby', require: 'ogn_client'
```

And then install the bundle:

```
bundle install --trust-policy MediumSecurity
```

### Standalone

If you're only going to use [the executables](#executables):

```
gem install ogn_client-ruby --trust-policy MediumSecurity
```

## Usage

### Subscribe to OGN

Choose a [valid callsign](http://www.aprs-is.net/Connecting.aspx#loginrules) and [appropriate filters](http://www.aprs-is.net/javAPRSFilter.aspx), then start listening to the broadcasted raw messages:

```ruby
require 'ogn_client'

OGNClient::APRS.start(callsign: "ROCT#{rand(1000)}", filter: 'r/47/2/500') do |aprs|
  while raw = aprs.gets
    puts raw   # do more interesting stuff here
  end
end
```

### Parse Raw Message Strings

:point_up: Refer to the wiki for an introduction to [OGN flavoured APRS](https://github.com/svoop/ogn_client-ruby/wiki) messages.

In the above example, each `aprs.gets` returns a raw message string. To decode this string, just pass it to the message parser:

```ruby
OGNClient::Message.parse(aprs.gets)
```

:point_up: Raw APRS messages as returned by `aprs.gets` are "ASCII-8BIT" encoded and may contain tailing whitespace. The parser removes this whitespace and converts the string to "UTF-8".

The factory method `OGNClient::Message.parse` will return one an instance of `OGNClient::Sender`, `OGNClient::Receiver`, `OGNClient::Comment` or [raise an error](#errors). When this happens, either the message is crippled, the [OGN](http://glidernet.org) specifications have changed or you have found a bug in the parser code.

In production, you may want to rescue from these errors and ignore the message. You should, however, log the offending messages messages, [file a bug](#community-support) and replay them once the bug has been fixed.

:point_up: Raw APRS messages do not contain the date, but assume the current day. This may cause trouble around midnight, however, the parser deals with such edge cases gracefully. Things are a little different when parsing raw APRS messages recorded in the past e.g. with `ognlogd`. Since the parser has no means to detect the date the APRS messages have been sent, you have to pass it as an option:

```ruby
raw_aprs = File.open('2017-06-24.log', &:gets)
OGNClient::Message.parse(raw_aprs, date: '2017-06-24')
```

#### OGNClient::SenderBeacon

Sender beacons are usually coming from aircraft equipped with [FLARM](https://flarm.com) (anti-collision warning system) or similar devices which broadcast position data as RF beacons.

The data is converted into the metric system since [OGN](http://glidernet.org) is primarily made for gliders which mostly use the metric system for ground speed, climb rate and so forth.

Attributes:
* **callsign** - origin callsign
* **receiver** - receiver callsign
* **time** - zulu/UTC time with date
* **longitude** - WGS84 degrees from -180 (W) to 180 (E)
* **latitude** - WGS84 degrees from -90 (S) to 90 (N)
* **altitude** - WGS84 meters above mean see level QNH
* **heading** - degrees from 1 to 360
* **ground_speed** - kilometers per hour
* **sender_type** - see [SENDER_TYPES](https://github.com/svoop/ogn_client-ruby/blob/master/lib/ogn_client/messages/sender.rb)
* **address_type** - see [ADDRESS_TYPES](https://github.com/svoop/ogn_client-ruby/blob/master/lib/ogn_client/messages/sender.rb)
* **id** - device ID
* **stealth_mode** - boolean (should always be false)
* **no_tracking** - boolean
* **flight_level** - 100 feet QNE
* **climb_rate** - meters per second
* **turn_rate** - revolutions per minute
* **signal_power** - power ratio in dBm
* **signal_quality** - signal to noise ratio in decibel
* **errors** - number of CRC errors
* **frequency_offset** - kilohertz
* **gps_accuracy** - array [vertical meters, horizontal meters]
* **flarm_software_version** - version as "major.minor"
* **flarm_hardware_version** - version as integer
* **flarm_id** - FLARM device ID
* **proximity** - array of FLARM device ID tails

#### OGNClient::ReceiverBeacon

Receivers are little RF boxes which pick up the RF beacons from aircraft and relay them to the OGN servers as messages. They send their own beacons on a regular basis.

Attributes:
* **callsign** - origin callsign
* **receiver** - receiver callsign
* **time** - zulu/UTC time with date
* **longitude** - WG84 degrees from -180 (W) to 180 (E)
* **latitude** - WG84 degrees from -90 (S) to 90 (N)
* **altitude** - WG84 meters above mean sea level QNH
* **heading** - degrees from 1 to 360
* **ground_speed** - kilometers per hour

Please note: These receiver beacons contained status information up until version 0.2.5.

#### OGNClient::ReceiverStatus

Receivers of version 0.2.6 and higher send status messages on a regular basis:

Attributes:
* **callsign** - origin callsign
* **receiver** - receiver callsign
* **time** - zulu/UTC time with date
* **version** - software version as "major.minor.patch"
* **platform** - e.g. :arm
* **cpu_load** - as reported by "uptime"
* **cpu_temperature** - in degrees celsius
* **ram_free** - megabytes
* **ram_total** - megabytes
* **ntp_offset** - milliseconds
* **ntp_correction** - parts-per-million
* **voltage** - board voltage in V
* **amperage** - board amperage in A
* **rf_correction_manual** - manual frequency correction as per configuration
* **rf_correction_automatic** - automatic frequency correction based on GSM
* **senders** - number of senders received within the last hour
* **visible_senders** - number of visible senders withint the last hour
* **invisible_senders** - number of invisible senders ("no-track" on device or "invisible" in database)
* **signal_quality** - signal-to-noise ratio in decibel
* **senders_signal_quality** - average signal-to-noise ratio across all senders
* **senders_messages** - number of messages analyzed to calculate the above
* **good_senders_signal_quality** - average signal-to-noise ratio in decibel of good senders (transmitting properly) within the last 24 hours
* **good_and_bad_senders** - number of good and bad senders within the last 24 hours
* **good_senders** - number of good senders (transmitting properly) within the last 24 hours
* **bad_senders** - number of bad senders (not transmitting properly) within the last 24 hours

#### OGNClient::Comment

Comments are sent on a regular basis to keep the connection alive.

Attribute:
* **comment** - raw message with the comment marker stripped

## Errors

The following domain specific errors may be raised:

* OGNClient::MessageError - errors during the parsing of a message
* OGNClient::ReceiverError - errors during the parsing of a receiver message

They all inherit from `OGNClient::Error`. An fault-tolerant subscription could therefore look as follows:

```ruby
require 'ogn_client'
require 'logger'

logger = Logger.new('/tmp/ogn_client.log')
options = { callsign: "ROCT#{rand(1000)}", filter: 'r/47/2/500' }
loop do
  OGNClient::APRS.start(options) do |aprs|
    while raw = aprs.gets
      begin
        message = OGNClient::Message.parse aprs.gets
      rescue OGNClient::Error => error
        logger.error error.message
        next
      end
      puts message.raw   # do more interesting stuff here
    end
  end
end
```

:point_up: Receiver versions ("major.minor.patch") are will only raise an error when the offending version has a higher major or minor version digit. Patch level differences will only trigger a warning.

## Executables

### ognlogd

A simple daemon to log raw APRS messages to daily files.

    ognlogd --help

### ogn2kml and ogn2geojson

Convert raw APRS messages (e.g. from `ognlogd`) to KML or GeoJSON.

    ogn2kml --help
    ogn2geojson --help

## Community Support

* Look for developers and users on [Gitter](https://gitter.im/svoop/ogn_client-ruby).
* Ask your questions on [Stackoverflow](https://stackoverflow.com/questions/ask?tags=ogn_client-ruby,ruby,gem).
* Annotated source code on [omniref](https://www.omniref.com/repositories/svoop/ogn_client-ruby)
* Bug reports, feature and pull requests are welcome on [GitHub](https://github.com/svoop/ogn_client-ruby).
* [Donations are welcome as well](https://donorbox.org/bitcetera-ogn_client-ruby)l. If you prefer to sponsor a feature, please create an issue on [GitHub](https://github.com/svoop/ogn_client-ruby) first and state your intentions.

## Development

To install the development dependencies and then run the test suite:

  bundle install
  bundle exec rake    # run tests once
  bundle exec guard   # run tests whenever files are modified
  
The test suite may run against live OGN data if you set the `SPEC_SCOPE` environment variable, by default, these tests are skipped.

```
export SPEC_SCOPE=all
```

Please submit issues on:

https://github.com/svoop/ogn_client-ruby/issues

To contribute code, fork the project on Github, add your code and submit a
pull request:

https://help.github.com/articles/fork-a-repo

## Feature Brainstorming

* registration lookups
* configuration option to switch between metric and aeronautical units
* more data sources such as ADS-B

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
