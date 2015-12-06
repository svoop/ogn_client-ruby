module OGNClient
  class << self

    # Print a debug message to STDOUT if $DEBUG is true
    #
    # If you want to print the message based on a condition, you can pass
    # it as a block:
    #
    #   debug('too young') { age < 16 }
    #
    # This block will only be evaluated if necessary.
    def debug(message)
      puts "DEBUG: #{message}" if $DEBUG && (!block_given? || yield)
    end

  end
end
