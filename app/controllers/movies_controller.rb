class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

   @sort = params['sort']
   @ratings = params[:ratings]
   @all_ratings = Movie.ratings
  
    if @ratings.nil? && @sort.nil?
      @movies = Movie.all
    elsif @ratings.nil? && !@sort.nil?
      @movies = Movie.find(:all, :order => 'title') if params['sort'] == 'title'
      @movies = Movie.find(:all, :order => 'release_date') if params['sort'] == 'release_date' 
    elsif !@ratings.nil? && @sort.nil?
      @movies = Movie.find_all_by_rating(@ratings.keys)
    else
      @movies = Movie.find_all_by_rating(@ratings.keys, :order => 'title') if params['sort'] == 'title'
      @movies = Movie.find_all_by_rating(@ratings.keys, :order => 'release_date') if params['sort'] == 'release_date'
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
