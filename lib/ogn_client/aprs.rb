module OGNClient

  # Minimalistic APRS implementation for OGN
  #
  # Use a unique all-uppercase callsign to create the instance and then
  # connect with or without filters.
  #
  #   OGNClient::APRS.start(callsign: 'OGNC', filter: 'r/33/-97/200') do |aprs|
  #     puts aprs.gets until aprs.eof?
  #   end
  #
  # See http://www.aprs-is.net/javAPRSFilter.aspx for available filters.
  class APRS

    SERVER = 'aprs.glidernet.org'
    PORT_FILTERED = 14580
    PORT_UNFILTERED = 10152
    AGENT = "#{RUBY_ENGINE}-ogn_client"

    attr_reader :callsign, :filter, :socket

    def initialize(callsign:, filter: nil)
    	@callsign = callsign.upcase
      @filter = filter
      @port = filter ? PORT_FILTERED : PORT_UNFILTERED
    end

    def self.start(callsign:, filter: nil, &block)
      new(callsign: callsign, filter: filter).start(&block)
    end

    def start
    	@socket = TCPSocket.open SERVER, @port
      @socket.puts handshake
      @socket.flush
      if block_given?
        begin
          return yield(@socket)
        ensure
          @socket.close
        end
      end
      self
    end

    private

    # Calculate the passcode from the callsign
    def passcode(readonly: true)
      if readonly
        -1
      else
      	@callsign.split('-').first.chars.reduce([0x73E2, true]) do |hash, char|
          [hash.first ^ (hash.last ? char.ord << 8 : char.ord), !hash.last]
      	end.first & 0x7FFF
      end
    end

    # Build the handshake to connect to the server
    def handshake(readonly: true)
      {
        user: @callsign,
        pass: passcode(readonly: readonly),
        vers: "#{AGENT} #{OGNClient::VERSION}",
        filter: @filter
      }.map { |k, v| "#{k} #{v}" if v }.compact.join(' ')
    end

  end
end
