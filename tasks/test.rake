require 'ogn_client'
require 'tempfile'
require 'fileutils'

namespace :test do

  desc "Reset the test suite"
  task :reset do
    FileUtils.rm_f('spec/fixtures/messages.txt')
  end

  desc "Feed live APRS messages to the parser"
  task :live do
    callsign = "ROCT#{rand(1000)}"
    counter = 0
    loop do
      OGNClient::APRS.start(callsign: callsign) do |aprs|
        while raw = aprs.gets do
          begin
            OGNClient::Message.parse raw
          rescue OGNClient::Error => error
            puts "ERROR: #{error.message}"
          end
          counter += 1
          puts "INFO: captured #{counter} messages" if counter % 1000 == 0
        end
      end
    end
  end

  namespace :live do
    desc "Record live APRS messages"
    task :record do
      callsign = "ROCT#{rand(1000)}"
      counter = 0
      File.open("#{Dir.tmpdir}/ogn_messages.txt", "w") do |file|
        OGNClient::APRS.start(callsign: callsign) do |aprs|
          while raw = aprs.gets do
            file.print raw
            counter += 1
            puts "INFO: captured #{counter} messages" if counter % 1000 == 0
          end
        end
      end
    end

    desc "Feed recorded APRS messages to the parser"
    task :replay do
      File.open("#{Dir.tmpdir}/ogn_messages.txt") do |file|
        while raw = file.gets do
          begin
            OGNClient::Message.parse raw
          rescue OGNClient::Error => error
            puts "ERROR: #{error.message}"
            exit
          end
        end
      end
    end
  end

end
