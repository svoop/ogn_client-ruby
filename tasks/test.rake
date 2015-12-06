
namespace :test do

  desc "Parse real-time APRS messages and test the parser"
  task :parser do
    $DEBUG = true
    require 'ogn_client'
    OGNClient::APRS.start(callsign: 'ROCT') do |aprs|
      10_000.times do
        raw = aprs.gets
        message = OGNClient::Message.parse raw
        print '.'
        if message.instance_of? OGNClient::Message
          puts '', '', 'Oops! Could not parse the following message:', '', raw, '', message.inspect
          break
        end
      end
    end
  end

end
