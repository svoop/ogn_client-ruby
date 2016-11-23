module OGNClient

  class Receiver < Message

    RECEIVER_PATTERN = %r(
      (?:
        v(?<version>\d+\.\d+\.\d+)
        (?:\.(?<platform>.+?))?
      \s)?
      CPU:(?<cpu_load>[\d.]+)\s
      RAM:(?<ram_free>[\d.]+)/(?<ram_total>[\d.]+)MB\s
      NTP:(?<ntp_offset>[\d.]+)ms/(?<ntp_correction>[+-][\d.]+)ppm\s
      (?:(?<voltage>[\d.]+)V\s)?
      (?:(?<amperage>[\d.]+)A\s)?
      (?:(?<cpu_temperature>[+-][\d.]+)C\s*)?
      (?:(?<visible_senders>\d+)/(?<senders>\d+)Acfts\[1h\]\s*)?
      (?:RF:
        (?:
          (?<rf_correction_manual>[+-][\d]+)
          (?<rf_correction_automatic>[+-][\d.]+)ppm/
        )?
        (?<signal_quality>[+-][\d.]+)dB
        (?:/(?<senders_signal_quality>[+-][\d.]+)dB@10km\[(?<senders_messages>\d+)\])?
        (?:/(?<good_senders_signal_quality>[+-][\d.]+)dB@10km\[(?<good_senders>\d+)/(?<good_and_bad_senders>\d+)\])?
      )?
    $)x

    ACCEPTED_RECEIVER_VERSION = Gem::Dependency.new('', '< 0.3')
    SUPPORTED_RECEIVER_VERSION = Gem::Dependency.new('', '<= 0.2.5')

    attr_reader :version                       # software version as "major.minor.patch"
    attr_reader :platform                      # e.g. "ARM"
    attr_reader :cpu_load                      # as reported by "uptime"
    attr_reader :cpu_temperature               # degrees celsius
    attr_reader :ram_free                      # megabytes
    attr_reader :ram_total                     # megabytes
    attr_reader :ntp_offset                    # milliseconds
    attr_reader :ntp_correction                # parts-per-million
    attr_reader :voltage                       # board voltage in V
    attr_reader :amperage                      # board amperage in A
    attr_reader :rf_correction_manual          # as per configuration
    attr_reader :rf_correction_automatic       # based on GSM
    attr_reader :senders                       # number of senders within the last hour
    attr_reader :visible_senders               # number of visible senders within the last hour
    attr_reader :signal_quality                # signal-to-noise ratio in decibel
    attr_reader :senders_signal_quality        # average signal-to-noise ratio in decibel across all senders
    attr_reader :senders_messages              # number of messages analyzed to calculate the above
    attr_reader :good_senders_signal_quality   # average signal-to-noise ratio in decibel of good senders (transmitting properly) within the last 24 hours
    attr_reader :good_and_bad_senders          # number of good and bad senders within the last 24 hours
    attr_reader :good_senders                  # number of good senders (transmitting properly) within the last 24 hours

    def invisible_senders
      senders - visible_senders
    rescue
      nil
    end

    def bad_senders
      good_and_bad_senders - good_senders
    rescue
      nil
    end

    private

    def parse(raw)
      raw.match RECEIVER_PATTERN do |match|
        super unless @raw
        %i(version platform cpu_load cpu_temperature ram_free ram_total ntp_offset ntp_correction voltage amperage rf_correction_manual rf_correction_automatic senders visible_senders signal_quality senders_signal_quality senders_messages good_senders_signal_quality good_and_bad_senders good_senders).each do |attr|
          send("#{attr}=", match[attr]) if match[attr]
        end
        self
      end
    end

    def version=(raw)
      @version = raw
      fail(OGNClient::ReceiverError, "unacceptable receiver version `#{@version}'") unless ACCEPTED_RECEIVER_VERSION.match?('', @version)
      warn("unsupported receiver version `#{@version}'") unless SUPPORTED_RECEIVER_VERSION.match?('', @version)
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

    def voltage=(raw)
      @voltage = raw.to_f.round(3)
    end

    def amperage=(raw)
      @amperage = raw.to_f.round(3)
    end

    def rf_correction_manual=(raw)
      @rf_correction_manual = raw.to_i
    end

    def rf_correction_automatic=(raw)
      @rf_correction_automatic = raw.to_f.round(1)
    end

    def senders=(raw)
      @senders = raw.to_i
    end

    def visible_senders=(raw)
      @visible_senders = raw.to_i
    end

    def signal_quality=(raw)
      @signal_quality = raw.to_f.round(3)
    end

    def senders_signal_quality=(raw)
      @senders_signal_quality = raw.to_f.round(3)
    end

    def senders_messages=(raw)
      @senders_messages = raw.to_i
    end

    def good_senders_signal_quality=(raw)
      @good_senders_signal_quality = raw.to_f.round(3)
    end

    def good_and_bad_senders=(raw)
      @good_and_bad_senders = raw.to_i
    end

    def good_senders=(raw)
      @good_senders = raw.to_i
    end

  end

end
