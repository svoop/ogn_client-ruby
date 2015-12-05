module OGNClient
  class << self

    def debug(message)
      puts "DEBUG: #{message}" if $DEBUG
    end

  end
end
