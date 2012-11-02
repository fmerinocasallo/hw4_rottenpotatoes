require "spec_helper"

describe MoviesController do
  before(:each) do
    @star_wars = mock('Movie', :id => '1', :title => 'Star Wars', :director => 'George Lucas')
  end

  describe "Showing movies" do
    it "should call the model method that performs ID search" do
      Movie.should_receive(:find).with('1')
      get :show, :id => 1
    end
  end

  describe "Indexing movies" do
    it "should call the model method that performs ID search" do
      Movie.should_receive(:all_ratings).and_return(%w(G PG PG-13 NC-17 R))
      Movie.should_receive(:find_all_by_rating)
      get :index
    end

    it "should redirect to a sorted by title view if indicated" do
      all_ratings = %w(G PG PG-13 NC-17 R)
      selected_ratings = Hash[all_ratings.map {|rating| [rating, rating]}]
      Movie.stub(:all_ratings).and_return(all_ratings)
      Movie.stub(:find_all_by_rating)
      get :index, :sort => 'title'
      response.should  redirect_to(:action => 'index', :sort => 'title', :ratings => selected_ratings)
    end

    it "should redirect to a sorted by release_date view if indicated" do
      all_ratings = %w(G PG PG-13 NC-17 R)
      selected_ratings = Hash[all_ratings.map {|rating| [rating, rating]}]
      Movie.stub(:all_ratings).and_return(all_ratings)
      Movie.stub(:find_all_by_rating)
      get :index, :sort => 'release_date'
      response.should  redirect_to(:action => 'index', :sort => 'release_date', :ratings => selected_ratings)
    end

    it "should show only the indicated ratings" do
      all_ratings = %w(PG R)
      selected_ratings = Hash[all_ratings.map {|rating| [rating, rating]}]
      Movie.stub(:all_ratings).and_return(%w(G PG PG-13 NC-17 R))
      Movie.stub(:find_all_by_rating)
      get :index, :ratings => selected_ratings
      response.should  redirect_to(:action => 'index', :ratings => selected_ratings)
    end
  end

  describe "Creating movies" do
    it "should call the model method that performs insert in the db" do
      Movie.should_receive(:create!).with({'title' => 'Star Wars', 'director' => 'George Lucas'}).and_return(@star_wars)
      post :create, {:movie => {:title => 'Star Wars', :director => 'George Lucas'}}
    end

    it "should redirect to RP home page with message" do
      Movie.stub(:create!).and_return(@star_wars)
      post :create, {:movie => {:title => 'Star Wars', :director => 'George Lucas'}}
      response.should redirect_to(:action => 'index')
    end
  end

  describe "Editing movies" do
    it "should call the model method that performs ID search" do
      Movie.should_receive(:find).with('1')
      get :edit, :id => 1
    end
  end

  describe "Updating movies" do
    it "should call the model method that performs updates in the db" do
      Movie.should_receive(:find).with('1').and_return(@star_wars)
      @star_wars.should_receive(:update_attributes!)
      put :update, :id => 1
    end

    # it "should redirect to RP home page with message" do
    #   Movie.stub(:find).and_return(@star_wars)
    #   @star_wars.stub(:update_attributes!)
    #   put :update, :id => 1
    #   response.should redirect_to(:action => 'show', :id => '1')
    # end
  end

  describe "Deleting movies" do
    it "should call the model method that performs delete in the db" do
      Movie.should_receive(:find).with('1').and_return(@star_wars)
      @star_wars.should_receive(:destroy)
      delete :destroy, :id => 1
    end

    it "should redirect to RP home page with message" do
      Movie.stub(:find).and_return(@star_wars)
      @star_wars.stub(:destroy)
      delete :destroy, :id => 1
      response.should redirect_to(:action => 'index')
    end
  end

  describe "Searching for Similar Movies" do
    it "should call the model method that performs Director search" do
      Movie.should_receive(:find).with('1').and_return(@star_wars)
      Movie.should_receive(:director_movies).with('George Lucas', 'Star Wars')
      get :director, :id => 1
    end

    it "should select (new) \"Similar Movies\" view to display match" do
      Movie.stub(:find).and_return(@star_wars)
      Movie.stub(:director_movies)
      get :director, :id => 1
      response.should render_template('director')
    end

    it "should make the Director search results available to that template" do
      fake_results = [mock('Movie'), mock('Movie')]
      Movie.stub(:find).and_return(@star_wars)
      Movie.stub(:director_movies).and_return(fake_results)
      get :director, :id => 1
      # Look for controller method to assign @movies
      assigns(:movies).should == fake_results
    end

    it "should redirect to RP home page with message if no match found" do
      alien = mock('Movie', :title => 'Alien', :director => nil)
      Movie.stub(:find).and_return(alien)
      get :director, :id => 1
      response.should redirect_to(:action => 'index')
    end
  end
end
