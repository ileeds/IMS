require 'pstore'
require_relative 'Artist.rb'
require_relative 'Track.rb'

class IMS

  def initialize
    @store=PStore.new('store.pstore')
    @hash={:total_tracks=>0, :total_artists=>0, :one=>nil, :two=>nil, :three=>nil}
    @input=nil
  end

  attr_accessor :store
  attr_accessor :hash
  attr_accessor :input

  def start
    if File.exist?('store.pstore')
      @store.transaction do
        @hash=@store[:data]
      end
    end
    command=nil
    puts "Welcome to the Interactive Music Shell!\nEnter your command (Help for info)"
    while command!="exit" do
      @input=gets.chomp.downcase
      command=@input.partition(" ").first
      @input=@input.split(' ')[1..-1].join(' ')
      key_table={
        "exit"=>"exit",
        "help"=>"help",
        "info"=>"info(@input)",
        "add"=>"add(@input)",
        "play"=>"play(@input)",
        "count"=>"count(@input)",
        "list"=>"list(@input)"
      }
      if key_table.key?(command)
        instance_eval(key_table[command])
      else
        puts "Please input again"
      end
    end
    @store.transaction do
      @store[:data]=@hash
    end
  end

  def exit
  end

  def help
    puts "Help - display a simple help screen
          Exit - save state and exit
          Info - display a summary of the state
          Info track - Display info about a certain track by number
          Info artist - Display info about a certain artist, by id
          Add Artist - Adds a new artist to storage and assign an artist id
          Play Track - Record that an existing track was played at the current time
          Count tracks - Display how many tracks are known by a certain artist
          List tracks - Display the tracks played by a certain artist"
  end

  def info(input)
    if input==""
      puts "Last three tracks played: #{@hash[:one]}, #{@hash[:two]}, #{@hash[:three]}
      Total number of tracks: #{@hash[:total_tracks]}
      Total number of artists: #{@hash[:total_artists]}"
    else
      info_type=input.partition(" ").first
      need_info=input.split(' ')[1..-1].join(' ')
      if info_type=="track"
        puts "Song title: #{@hash[need_info].title}\nArtist: #{@hash[need_info].artist}\nPlay count: #{@hash[need_info].plays}"
      elsif info_type=="artist"
        puts "Artist name: #{@hash[need_info].name}\nArtist ID: #{need_info}"
      else
        puts "Please input again"
      end
    end
  end

  def add(input)
    add_type=input.partition(" ").first
    to_add=input.split(' ')[1..-1].join(' ')
    if add_type=="artist"
      artist=Artist.new(to_add)
      id=artist.id
      while @hash.has_key?(id)
        number=Random.new.rand(0..9).to_s
        id=id+number
      end
      @hash[id]=artist
      @hash[:total_artists]=@hash[:total_artists]+1
      puts "Artist ID is #{id}"
    elsif add_type=="track"
      artist_id=input.split.last
      if !@hash.has_key?(artist_id)
        puts "Artist ID does not exist"
      else
        track=to_add.split(' ')[0..-3].join(' ')
        @hash[:total_tracks]=@hash[:total_tracks]+1
        @hash[artist_id].add_track(track, @hash[:total_tracks])
        @hash[@hash[:total_tracks].to_s]=Track.new(track, @hash[:total_tracks], @hash[artist_id].name)
        puts "Track number is #{@hash[:total_tracks]}"
      end
    else
      puts "Please input again"
    end
  end

  def play(input)
    track=input.split(' ')[1..-1].join(' ')
    @hash[track].set_time
    @hash[track].plus_plays
    @hash[:three]=@hash[:two]
    @hash[:two]=@hash[:one]
    @hash[:one]=@hash[track]
    puts "Playing track #{track}"
  end

  def count(input)
    artist=input.split(' ')[2..-1].join(' ')
    puts "This artist has #{@hash[artist].tracks.size} tracks."
  end

  def list(input)
    artist=input.split(' ')[2..-1].join(' ')
    puts @hash[artist].tracks
  end

a=IMS.new
a.start

end
