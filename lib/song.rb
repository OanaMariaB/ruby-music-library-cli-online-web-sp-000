require 'pry'

class Song
  attr_accessor :name
  attr_reader :artist, :genre
  extend Concerns::Findable

  @@all = []

  def initialize(name, artist = nil, genre = nil)
    @name = name
    @genre = genre
    self.artist=(artist) if artist
    self.genre=(genre) if genre
  end

 def self.all
    @@all
  end

  def self.destroy_all
    @@all.clear
  end

  def save
    @@all << self
  end

  def self.create(name)
     song = self.new(name)
     song.save
     song
  end

  def artist=(artist)
    @artist = artist
    artist.add_song(self)
  end

  def genre=(genre)
    @genre = genre
     genre.songs << self unless genre.songs.include?(self)
  end

  def self.new_from_filename(name)
     artist, song, genre_name = name.split(' - ')
     fixed_name = genre_name.gsub('.mp3', '')
     artist = Artist.find_or_create_by_name(artist)
     genre = Genre.find_or_create_by_name(fixed_name)
     new(song, artist, genre)
  end

  def self.create_from_filename(name)
    new_from_filename(name).save
  end


end
