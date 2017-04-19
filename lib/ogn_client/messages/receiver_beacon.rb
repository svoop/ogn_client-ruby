module OGNClient

  class ReceiverBeacon < Message

    RECEIVER_BEACON_PATTERN = %r(^
      .+?>APRS,(?:.+?,){1,2}
      (?:GLIDERN|GIGA|NYMSERV)\d*:
    )x

    private

    def parse(raw)
      raw.match RECEIVER_BEACON_PATTERN do
        super unless @raw
        self
      end
    end

  end

end
