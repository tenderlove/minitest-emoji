require 'minitest/autorun'

module Minitest

  def self.plugin_emoji_options opts, options # :nodoc:
    opts.on "-e", "--emoji", "Show Emoji instead of dots" do
      Emoji.emoji!
    end
    opts.on "-t", "--theme [name]", "Pick an emoji theme" do |name|
      unless name
        puts "Choose from these themes:"
        Emoji.themes.keys.each{|theme| puts "  #{theme}" }
        puts "...or, 'random' for a random theme"
        exit 1
      end
      Emoji.theme! name
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

    attr_reader :io, :chars

    def self.emoji!
      @emoji = true
    end

    def self.emoji?
      @emoji ||= false
    end

    def self.theme! name
      if name == "random"
        name = self.themes.keys.sample
      end
      unless self.themes.include? name.to_sym
        puts "Theme #{name} not found."
        exit 1
      end
      @theme ||= self.themes[name.to_sym]
    end

    def self.theme
      @theme ||= self.themes[:default]
    end

    def self.themes
      @themes ||= {}
    end

    def self.add_theme name, chars
      self.themes[name.to_sym] = chars
    end

    def initialize io
      @io    = io
      @chars = self.class.theme
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

# require all the themes
Dir[File.join(File.dirname(__FILE__), 'emoji', 'themes', '*.rb')].each {|file| require file }
