require 'minitest'

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

    def self.add_utf_theme name, p=0x1f49a, f=0x1f4a9, e=0x1f525, s=0x1f633
      p, f, e, s = [p, f, e, s].pack("U*").chars.map { |c| "#{c} " }
      add_theme name, "." => p, "E" => e, "F" => f, "S" => s
    end

    def self.copy_theme to, from
      themes[to] = themes[from]
    end

    add_utf_theme :default
    add_utf_theme :apples,  0x1f34f, 0x1f34a, 0x1f34e, 0x1f34b
    add_utf_theme :farm,    0x1f414, 0x1f42e, 0x1f437, 0x1f439
    add_utf_theme :hearts,  0x1f49a, 0x1f49b, 0x1f494, 0x1f499
    add_utf_theme :kitties, 0x1f63b, 0x1f640, 0x1f63f, 0x1f63d
    add_utf_theme :smilies, 0x1f60d, 0x1f631, 0x1f621, 0x1f61c
    add_utf_theme :weather, 0x02600, 0x026a1, 0x02614, 0x02601
    add_utf_theme :xoxo,    0x02b55, 0x0274c, 0x02049, 0x02753
    add_utf_theme :jan,     0x026c4
    add_utf_theme :feb,     0x1f498, 0x1f494
    add_utf_theme :mar,     0x1f340
    add_utf_theme :apr,     0x02614, 0x026a1
    add_utf_theme :may,     0x1f33b, 0x1f335
    add_utf_theme :jun,     0x1f31e, 0x026c5, 0x02601, 0x026a1
    add_utf_theme :jul,     0x1f386
    copy_theme    :aug,     :jun
    add_utf_theme :sep,     0x1f342
    add_utf_theme :oct,     0x1f383, 0x1f47b
    add_utf_theme :nov,     0x1f357
    add_utf_theme :dec,     0x1f385

    copy_theme :random,  themes.keys.sample
    copy_theme :monthly, Time.now.strftime("%b").downcase.to_sym

    def self.show_all_themes
      themes.each do |n, c|
        puts "%10s: %s%s%s%s" % [n, c["."], c["F"], c["E"], c["S"] ]
      end
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
