class Track

  def initialize(title, number, artist)
    @title=title
    @number=number
    @time=nil
    @plays=0
    @artist=artist
  end

  def to_s
    @title
  end

  def set_time
    @time=Time.now
  end

  def plus_plays
    @plays=@plays+1
  end

  def ==(other)
    other.class == self.class && other.state == state
  end

  def state
    [@title, @number, @plays, @artist]
  end

  attr_accessor :title
  attr_accessor :number
  attr_accessor :time
  attr_accessor :plays
  attr_accessor :artist

end
