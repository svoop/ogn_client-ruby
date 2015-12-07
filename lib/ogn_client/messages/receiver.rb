module OGNClient

  class Receiver < Message

    RECEIVER_PATTERN = %r(
      (?:
        v(?<version>\d+\.\d+\.\d+)
        (?:\.(?<platform>.+?))?
      \s)?
      CPU:(?<cpu_load>[\d.]+)\s
      RAM:(?<ram_free>[\d.]+)/(?<ram_total>[\d.]+)MB\s
      NTP:(?<ntp_offset>[\d.]+)ms/(?<ntp_correction>[+-][\d.]+)ppm\s?
      (?:(?<cpu_temperature>[+-][\d.]+)C\s*)?
      (?:RF:
        (?:
          (?<manual_correction>[+-][\d]+)
          (?<automatic_correction>[+-][\d.]+)ppm/
        )?
        (?<signal>[+-][\d.]+)dB
      )?
    $)x

    SUPPORTED_RECEIVER_VERSION = Gem::Version.new('0.2.5')

    attr_reader :version                # software version as #<Gem::Version "major.minor.patch">
    attr_reader :platform               # e.g. "ARM"
    attr_reader :cpu_load               # as reported by "uptime"
    attr_reader :cpu_temperature        # degrees celsius
    attr_reader :ram_free               # megabytes
    attr_reader :ram_total              # megabytes
    attr_reader :ntp_offset             # milliseconds
    attr_reader :ntp_correction         # parts-per-million
    attr_reader :manual_correction      # as per configuration
    attr_reader :automatic_correction   # based on GSM
    attr_reader :signal                 # signal-to-noise ratio in decibel

    private

    def parse(raw)
      @raw = raw
      @raw.match RECEIVER_PATTERN do |match|
        return unless super
        %i(version platform cpu_load cpu_temperature ram_free ram_total ntp_offset ntp_correction manual_correction automatic_correction signal).each do |attr|
          send("#{attr}=", match[attr]) if match[attr]
        end
        self
      end
    end

    def version=(raw)
      @version = Gem::Version.new(raw)
      fail(OGNClient::ReceiverError, "unsupported receiver version: `#{@raw}'") if @version > SUPPORTED_RECEIVER_VERSION
      @version
    end

    def platform=(raw)
      @platform = raw.to_sym.downcase
    end

    def cpu_load=(raw)
      @cpu_load = raw.to_f.round(2)
    end

    def cpu_temperature=(raw)
      @cpu_temperature = raw.to_f.round(2)
    end

    def ram_free=(raw)
      @ram_free = raw.to_f.round(2)
    end

    def ram_total=(raw)
      @ram_total = raw.to_f.round(2)
    end

    def ntp_offset=(raw)
      @ntp_offset = raw.to_f.round(2)
    end

    def ntp_correction=(raw)
      @ntp_correction = raw.to_f.round(2)
    end

    def manual_correction=(raw)
      @manual_correction = raw.to_i
    end

    def automatic_correction=(raw)
      @automatic_correction = raw.to_f.round(1)
    end

    def signal=(raw)
      @signal = raw.to_f.round(3)
    end

  end

end
