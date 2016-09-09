class Artist

  def initialize(name)
    @name=name
    @tracks=[]
  end

  def add_track(title, number)
    tracks.push(Track.new(title, number, @name))
  end

  def id
    @name.split.map(&:chr).join.downcase
  end

  def to_s
    @name
  end

  def ==(other)
    other.class == self.class && other.state == state
  end

  def state
    [@name, @tracks]
  end

  attr_accessor :name
  attr_accessor :tracks

end
