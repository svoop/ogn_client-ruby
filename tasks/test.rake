require 'ogn_client'

namespace :test do

  desc "Receive and dump real-time APRS messages"
  task :receiver do
    OGNClient::APRS.start(callsign: "ROCT-#{rand(100)}") do |aprs|
      loop do
        print aprs.gets
      end
    end
  end

  desc "Parse real-time APRS messages and test the parser"
  task :parser do
    callsign = "ROCT-#{rand(100)}"
    loop do
      OGNClient::APRS.start(callsign: callsign) do |aprs|
        while raw = aprs.gets do
          print '.'
          begin
            OGNClient::Message.parse raw
          rescue OGNClient::Error => error
            puts
            warn "WARNING: #{error.message}"
          end
        end
      end
    end
  end

end
