class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.director_movies (director, title)
  	self.find_all_by_director(director, :conditions => [ "title != ?", title])
  end
end
