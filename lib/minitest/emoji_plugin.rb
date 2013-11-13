require 'minitest/autorun'

module Minitest

  def self.plugin_emoji_options opts, options # :nodoc:
    opts.on "-e", "--emoji", "Show Emoji instead of dots" do
      Emoji.emoji!
    end
  end

  def self.plugin_emoji_init options # :nodoc:
    if Emoji.emoji? then
      io = Emoji.new options[:io]

      self.reporter.reporters.grep(Minitest::Reporter).each do |rep|
        rep.io = io
      end
    end
  end

  class Emoji

    VERSION = '1.0.0'

    DEFAULT = {
      '.' => "\u{1F49A} ",
      'E' => "\u{1f525} ",
      'F' => "\u{1f4a9} ",
      'S' => "\u{1f633} ",
    }

    attr_reader :io, :chars

    def self.emoji!
      @emoji = true
    end

    def self.emoji?
      @emoji ||= false
    end

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
