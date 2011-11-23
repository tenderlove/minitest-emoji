require 'minitest/autorun'
require 'minitest/emoji'

describe 'my amazing tests' do
  # generate many hearts!
  50.times do |i|
    it "must #{i}" do
      100.must_equal 100
    end
  end

  # generate some poops!
  2.times do |i|
    it "compares #{i} to #{i + 1}" do
      i.must_equal i + 1
    end
  end

  it 'skips things!!' do
    skip "don't care!"
  end
end
