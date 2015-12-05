module OGNClient

  # Generic OGN flavoured APRS parser
  #
  # You can pass any raw OGN flavoured APRS message string to the +parse+ class
  # method and receive an instance of the appropriate subclass (+Comment+,
  # +Receiver+ or +Sender+) or +nil+ if the message string could not be parsed.
  #
  # Comment example:
  #   raw = "# aprsc 2.0.14-g28c5a6a 29 Jun 2014 07:46:15 GMT GLIDERN1 37.187.40.234:14580"
  #   obj = OGNClient::Message.parse(raw)   # => #<OGNClient::Comment:0x007feaf1012898>
  #   obj.comment   # => "aprsc 2.0.14-g28c5a6a 29 Jun 2014 07:46:15 GMT GLIDERN1 37.187.40.234:14580"
  #
  # Sender example:
  #   raw = "FLRDF0A52>APRS,qAS,LSTB:/220132h4658.70N/00707.72Ez090/054/A=001424 id06DF0A52 +020fpm +0.0rot 55.2dB 0e -6.2kHz"
  #   obj = OGNClient::Message.parse(raw)   # => #<OGNClient::Sender:0x007feaec1daba8>
  #   obj.id   # => "DF0A52"
  #
  # Malformed example:
  #   raw = "FOOBAR>not a valid message"
  #   obj = OGNClient::Message.parse(raw)   # => nil
  class Message

    POSITION_PATTERN = %r(^
      (?<callsign>\w+?)>APRS,.+?,
      (?<receiver>\w+):/
      (?<time>\d{6})h
      (?<latitude>\d{4}\.\d{2}[NS]).
      (?<longitude>\d{5}\.\d{2}[EW]).
      (?:(?<heading>\d{3})/(?<speed>\d{3}))?.*?
      /A=(?<altitude>\d{6})\s
      (?:!W((?<latitude_enhancement>\d)(?<longitude_enhancement>\d))!)?
    )x

    attr_reader :raw
    attr_reader :callsign    # origin callsign
    attr_reader :receiver    # receiver callsign
    attr_reader :time        # zulu time with date
    attr_reader :longitude   # degrees from -180 (W) to 180 (E)
    attr_reader :latitude    # degrees from -90 (S) to 90 (N)
    attr_reader :altitude    # meters
    attr_reader :heading     # degrees from 1 to 360
    attr_reader :speed       # kilometers per hour

    def self.parse(raw)
      OGNClient::Sender.new.parse(raw) ||
        OGNClient::Receiver.new.parse(raw) ||
        OGNClient::Comment.new.parse(raw) ||
        new.parse(raw)
    end

    def parse(raw)
      @raw = raw
      raw.match(POSITION_PATTERN) do |match|
        %i(callsign receiver time altitude).each do |attr|
          send "#{attr}=", match[attr]
        end
        self.heading = match[:heading] if match[:heading] && match[:heading] != '000'
        self.speed = match[:speed] if match[:speed] && match[:heading] != '000'
        self.longitude = [match[:longitude], match[:longitude_enhancement]]
        self.latitude = [match[:latitude], match[:latitude_enhancement]]
        self
      end || OGNClient.debug("invalid message: `#{@raw}'")
      self
    end

    def to_s
      @raw
    end

    private

    def callsign=(raw)
      @callsign = raw
    end

    def receiver=(raw)
      @receiver = raw
    end

    def time=(raw)
      now = Time.now.utc
      @time = Time.new(now.year, now.month, now.day, raw[0,2], raw[2,2], raw[4,2], 0).tap do |time|
        time -= 86400 if time > now   # adjust date of beacons sent just before midnight
      end
    end

    def longitude=(raw)
      raw.first.match /(\d{3})([\d.]+)([EW])/
      @longitude = (($1.to_f + ("#{$2}#{raw.last}".to_f / 60)) * ($3 == 'E' ? 1 : -1)).round(6)
    end

    def latitude=(raw)
      raw.first.match /(\d{2})([\d.]+)([NS])/
      @latitude = (($1.to_f + ("#{$2}#{raw.last}".to_f / 60)) * ($3 == 'N' ? 1 : -1)).round(6)
    end

    def altitude=(raw)
      @altitude = (raw.to_i / 3.2808).round
    end

    def heading=(raw)
      @heading = raw.to_i
    end

    def speed=(raw)
      @speed = (raw.to_i * 1.852).round
    end

  end

end
