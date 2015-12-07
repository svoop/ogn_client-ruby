
namespace :test do

  desc "Parse real-time APRS messages and test the parser"
  task :parser do
    require 'ogn_client'
    OGNClient::APRS.start(callsign: 'ROCT') do |aprs|
      loop do
        print '.'
        raw = aprs.gets
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
