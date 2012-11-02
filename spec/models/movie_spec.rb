require "spec_helper"

describe Movie do
  describe "Searching Movies by Director" do
    before (:each) do
      @star_wars = Movie.create!(:title => 'Star Wars', :director => 'George Lucas')
      @thx_1138 = Movie.create!(:title => 'THX-1138', :director => 'George Lucas')
      @blade_runner = Movie.create!(:title => 'Blade Runner', :director => 'Ridley Scott')
      @alien = Movie.create!(:title => 'Alien')
    end

    it "should return all the movies from the specified director except the one we have previously selected" do
      similar = Movie.director_movies @star_wars.director, @star_wars.title
      similar == @thx_1138
    end

    it "should return nil in case no director has been selected or there are no movies in our db for that director" do
      similar = Movie.director_movies @alien.director, @alien.title
      similar.nil?
    end
  end

  describe "Getting @all_ratings" do
    it "should return all available ratings" do
      all_ratings = %w(G PG PG-13 NC-17 R)
      all_ratings == Movie.all_ratings
    end
  end
end
