module OGNClient

  class Comment < Message

    COMMENT_PATTERN = %r(^
      \#\s*(?<comment>.*?)\s*
    $)x

    attr_reader :comment   # free form text comment

    def parse(raw)
      @raw = raw
      raw.match COMMENT_PATTERN do |match|
        self.comment = match[:comment]
        self
      end
    end

    private

    def comment=(raw)
      @comment = raw
    end

  end

end
