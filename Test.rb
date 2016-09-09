require 'minitest/autorun'
require 'minitest/spec'
require 'pstore'
require_relative 'Artist.rb'
require_relative 'Track.rb'
require_relative 'IMS.rb'

describe "Artist" do
  it "preserves name" do
    a1=Artist.new("Beatles")
    a1.name.must_equal "Beatles"
  end
  it "has correct id" do
    a2=Artist.new("Ian and the Little Ians")
    a2.id.must_equal("iatli")
  end
  it "contains tracks" do
    a3=Artist.new("Beatles")
    a3.add_track("Help", 1)
    a3.add_track("A day IN the LIFE", 1)
    a3.add_track("Yellow Submarine", 1)
    a3.tracks.must_include Track.new("Help", 1, "Beatles")
    a3.tracks.must_include Track.new("A day IN the LIFE", 1, "Beatles")
    a3.tracks.must_include Track.new("Yellow Submarine", 1, "Beatles")
  end
  it "is equal" do
    a4=Artist.new("Beatles")
    a4.add_track("Help", 1)
    a4.add_track("A day IN the LIFE", 1)
    a4.add_track("Yellow Submarine", 1)
    a5=Artist.new("Beatles")
    a5.add_track("Help", 1)
    a5.add_track("A day IN the LIFE", 1)
    a5.add_track("Yellow Submarine", 1)
    a6=Artist.new("Beatles")
    a6.add_track("Help", 1)
    a6.add_track("A day IN the LIFE", 1)
    a6.add_track("Yellw Submarine", 1)
    a4.must_equal a5
    a5.wont_equal a6
  end
end

describe "Track" do
  it "preserves fields" do
    a1=Track.new("Safari", 3, "J Balvin")
    a2=Track.new("Safari", 3, "J Balvin")
    a3=Track.new("Safari", 3, "J Balvi")
    a1.must_equal a2
    a1.wont_equal a3
  end
end

describe "IMS" do
  it "adds artists" do
    a1=IMS.new
    a1.add("artist the beatles")
    b=a1.hash.has_value? Artist.new("the beatles")
    b.must_equal true
  end
  it "adds track" do
    a2=IMS.new
    a2.add("artist the beatles")
    a2.add("track help by tb")
    a2.hash["tb"].tracks.must_include(Track.new("help", 1,"the beatles"))
  end
end
