module MiniTest
  class Emoji
    VERSION = '1.0.0'

    DEFAULT = {
      '.' => "\u{1f497} ",
      'E' => "\u{1f525} ",
      'F' => "\u{1f4a9} ",
      'S' => "\u{1f633} ",
    }

    attr_reader :io, :chars

    def initialize io, chars = DEFAULT
      @io    = io
      @chars = DEFAULT
    end

    def print o
      io.print(chars[o] || o)
    end

    def method_missing msg, *args
      return super unless io.respond_to? msg
      io.send(msg, *args)
    end
  end
end

MiniTest::Unit.output = MiniTest::Emoji.new(MiniTest::Unit.output)
