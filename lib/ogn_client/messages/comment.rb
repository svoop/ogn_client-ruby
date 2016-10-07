module OGNClient

  class Comment < Message

    COMMENT_PATTERN = %r(^
      \#\s*(?<comment>.*?)\s*
    $)x

    attr_reader :comment   # free form text comment

    private

    def parse(raw)
      @raw ||= raw
      @raw.match COMMENT_PATTERN do |match|
        self.comment = match[:comment]
        self
      end
    end

    def comment=(raw)
      @comment = raw
    end

  end

end
