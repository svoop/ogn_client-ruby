[![Version](https://img.shields.io/gem/v/ogn_client-ruby.svg?style=flat)](https://rubygems.org/gems/ogn_client-ruby)
[![Continuous Integration](https://img.shields.io/travis/svoop/ogn_client-ruby/master.svg?style=flat)](https://travis-ci.org/svoop/ogn_client-ruby)
[![Code Climate](https://img.shields.io/codeclimate/github/svoop/ogn_client-ruby.svg?style=flat)](https://codeclimate.com/github/svoop/ogn_client-ruby)
[![Gitter](https://img.shields.io/gitter/room/svoop/ogn_client-ruby.svg?style=flat)](https://gitter.im/svoop/ogn_client-ruby)
[![Beerpay](https://img.shields.io/badge/beerpay-donate-yellow.svg)](https://beerpay.io/svoop/ogn_client-ruby)

# ogn_client-ruby

[OGN](http://glidernet.org) broadcasts aircraft positions as [APRS](http://www.aprs.org)/[APRS-IS](http://www.aprs-is.net) messages. This gem hooks into this stream of data and provides the necessary classes to parse the raw message strings into meaningful objects.

* Author: [Sven Schwyn](http://bitcetera.com)
* Homepage: https://github.com/svoop/ogn_client-ruby

:loudspeaker: A word from the shameless commerce division: Looking for a freelance Ruby developer? Surf to http://bitcetera.com and contact Sven. Or show your support with a [contribution on beerpay](https://beerpay.io/svoop/ogn_client-ruby).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ogn_client-ruby', require: 'ogn_client'
```

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install ogn_client-ruby

## Usage

### Subscribe to OGN

Choose a [valid callsign](http://www.aprs-is.net/Connecting.aspx#loginrules) and [appropriate filters](http://www.aprs-is.net/javAPRSFilter.aspx), then start listening to the broadcasted raw messages:

```ruby
OGNClient::APRS.start(callsign: 'ROCT', filter: 'r/33/-97/200') do |aprs|
  loop { puts aprs.gets }
end
```

### Parse Raw Message Strings

:point_up: Refer to the wiki for an introduction to [OGN flavoured APRS](https://github.com/svoop/ogn_client-ruby/wiki) messages.

In the above example, each `aprs.gets` returns a raw message string. To decode this string, just pass it to the message parser:

```ruby
OGNClient::Message.parse(aprs.gets)
```

:point_up: Raw APRS messages as returned by `aprs.gets` are "ASCII-8BIT" encoded and may contain tailing whitespace. The parser removes this whitespace and converts the string to "UTF-8".

The factory method `OGNClient::Message.parse` will return one an instance of `OGNClient::Sender`, `OGNClient::Receiver`, `OGNClient::comment` or [raise an error](#errors). When this happens, either the message is crippled, the [OGN](http://glidernet.org) specifications have changed or you have found a bug in the parser code. You may want to store such messages, [file a bug](#community-support) and replay them once the bug has been fixed.

#### OGNClient::Sender

Senders are usually aircraft equipped with [FLARM](https://flarm.com) (anti-collision warning system) or similar devices which broadcast position data as RF beacons.

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
* **stealth_mode** - boolean (should always be false)
* **no_tracking** - boolean
* **sender_type** - see [SENDER_TYPES](https://github.com/svoop/ogn_client-ruby/blob/master/lib/ogn_client/messages/sender.rb)
* **address_type** - see [ADDRESS_TYPES](https://github.com/svoop/ogn_client-ruby/blob/master/lib/ogn_client/messages/sender.rb)
* **id** - device ID
* **climb_rate** - meters per second
* **turn_rate** - revolutions per minute
* **flight_level** - 100 feet QNE
* **signal** - signal to noise ratio in decibel
* **errors** - number of CRC errors
* **frequency_offset** - kilohertz
* **gps_accuracy** - array [vertical meters, horizontal meters]
* **flarm_software_version** - version as #<Gem::Version "major.minor">
* **flarm_hardware_version** - version as #<Gem::Version "major">
* **flarm_id** - FLARM device ID
* **proximity** - array of FLARM device ID tails

#### OGNClient::Receiver

Receivers are little RF boxes which pick up the RF beacons from aircraft and relay them to the OGN servers as messages. They send their own status messages on a regular basis.

Attributes:
* **callsign** - origin callsign
* **receiver** - receiver callsign
* **time** - zulu/UTC time with date
* **longitude** - WG84 degrees from -180 (W) to 180 (E)
* **latitude** - WG84 degrees from -90 (S) to 90 (N)
* **altitude** - WG84 meters above mean sea level QNH
* **heading** - degrees from 1 to 360
* **ground_speed** - kilometers per hour
* **version** - software version as #<Gem::Version "major.minor.patch">
* **platform** - e.g. :arm
* **cpu_load** - as reported by "uptime"
* **cpu_temperature** - in degrees celsius
* **ram_free** - megabytes
* **ram_total** - megabytes
* **ntp_offset** - milliseconds
* **ntp_correction** - parts-per-million
* **signal** - signal-to-noise ratio in decibel

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
logger = Logger.new('/tmp/ogn_client.log')
OGNClient::APRS.start(callsign: 'ROCT', filter: 'r/33/-97/200') do |aprs|
  loop do
    begin
      message = OGNClient::Message.parse aprs.gets
    rescue OGNClient::Error => error
      logger.error error.message
    end
    puts message.raw
  end
end
```

## Community Support

* Look for developers and users on [Gitter](https://gitter.im/svoop/ogn_client-ruby).
* Ask your questions on [Stackoverflow](https://stackoverflow.com/questions/ask?tags=ogn_client-ruby,ruby,gem).
* Bug reports and pull requests are welcome on [GitHub](https://github.com/svoop/ogn_client-ruby).
* Submit a wish or sponsor a feature on [beerpay](https://beerpay.io/svoop/ogn_client-ruby).

## Development

Check out the repository, install the dependencies and run the test suite:

    $ git clone git@github.com:svoop/ogn_client-ruby.git
    $ cd ogn_client-ruby
    $ gem install bundler
    $ bin/setup
    $ rake

If you are on Mac OS X, +guard+, +guard-minitest+ and +minitest-osx+ are also installed and therefore you get the test results as notifications by running a guard watchdog with:

    $ guard

To play around with the gem:

    $ bin/console

And to install this gem onto your local machine:

    $ bundle exec rake install

## Feature Brainstorming

* registration lookups
* configuration option to switch between metric and aeronautical units
* more data sources such as ADS-B

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
