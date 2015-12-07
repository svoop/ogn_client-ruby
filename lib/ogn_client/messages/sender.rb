module OGNClient

  class Sender < Message

    SENDER_PATTERN = %r(
      id(?<details>\w{2})(?<id>\w+?)\s
      (?<climb_rate>[+-]\d+?)fpm\s
      (?<turn_rate>[+-][\d.]+?)rot\s
      (?:FL(?<flight_level>[\d.]+)\s)?
      (?<signal>[\d.]+?)dB\s
      (?<errors>\d+)e\s
      (?<frequency_offset>[+-][\d.]+?)kHz\s?
      (?:gps(?<gps_accuracy>\d+x\d+)\s?)?
      (?:s(?<flarm_software_version>[\d.]+)\s?)?
      (?:h(?<flarm_hardware_version>[\dA-F]{2})\s?)?
      (?:r(?<flarm_id>[\dA-F]+)\s?)?
      (?:hear(?<proximity>.+))?
    $)x

    SENDER_TYPES = {
       1 => :glider,
       2 => :tow_plane,
       3 => :helicopter_rotorcraft,
       4 => :parachute,
       5 => :drop_plane,
       6 => :hang_glider,
       7 => :para_glider,
       8 => :powered_aircraft,
       9 => :jet_aircraft,
      10 => :ufo,
      11 => :balloon,
      12 => :airship,
      13 => :uav,
      15 => :static_object
    }

    ADDRESS_TYPES = {
      0 => :random,
      1 => :icao,
      2 => :flarm,
      3 => :ogn
    }

    attr_reader :stealth_mode             # boolean
    attr_reader :no_tracking              # boolean
    attr_reader :sender_type              # see SENDER_TYPES
    attr_reader :address_type             # see ADDRESS_TYPES
    attr_reader :id                       # device ID
    attr_reader :climb_rate               # meters per second
    attr_reader :turn_rate                # revolutions per minute
    attr_reader :flight_level             # 100 feet QNE
    attr_reader :signal                   # signal to noise ratio in decibel
    attr_reader :errors                   # number of CRC errors
    attr_reader :frequency_offset         # kilohertz
    attr_reader :gps_accuracy             # array [vertical meters, horizontal meters]
    attr_reader :flarm_software_version   # version as #<Gem::Version "major.minor">
    attr_reader :flarm_hardware_version   # version as #<Gem::Version "major">
    attr_reader :flarm_id                 # FLARM device ID
    attr_reader :proximity                # array of FLARM device ID tails

    private

    def parse(raw)
      @raw = raw
      @raw.match SENDER_PATTERN do |match|
        return unless super
        %i(details id climb_rate turn_rate flight_level signal errors frequency_offset gps_accuracy flarm_software_version flarm_hardware_version flarm_id proximity).each do |attr|
          send("#{attr}=", match[attr]) if match[attr]
        end
        self.flarm_id ||= id if address_type == :icao || address_type == :flarm
        self
      end
    end

    def details=(raw)
      byte = raw.to_i(16)
      @stealth_mode = !(byte & 0b10000000).zero?
      @no_tracking = !(byte & 0b01000000).zero?
      @address_type = ADDRESS_TYPES.fetch((byte & 0b00000011), :unknown)
      @sender_type = SENDER_TYPES.fetch((byte & 0b00111100) >> 2, :unknown)
    end

    def id=(raw)
      @id = raw
    end

    def climb_rate=(raw)
      @climb_rate = (raw.to_i / 60.0 / 3.2808).round(1)
    end

    def turn_rate=(raw)
      @turn_rate = (raw.to_i / 4.0).round(1)
    end

    def flight_level=(raw)
      @flight_level = raw.to_f.round(2)
    end

    def signal=(raw)
      @signal = raw.to_f.round(1)
    end

    def errors=(raw)
      @errors = raw.to_i
    end

    def frequency_offset=(raw)
      @frequency_offset = raw.to_f.round(1)
    end

    def gps_accuracy=(raw)
      @gps_accuracy = raw.split('x').map(&:to_i)
    end

    def flarm_software_version=(raw)
      @flarm_software_version = Gem::Version.new raw
    end

    def flarm_hardware_version=(raw)
      @flarm_hardware_version = Gem::Version.new raw.to_i(16)
    end

    def flarm_id=(raw)
      @flarm_id = raw
    end

    def proximity=(raw)
      @proximity = raw.split(/\shear/)
    end

  end

end
