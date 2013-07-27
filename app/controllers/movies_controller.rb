class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    logger.debug("Session: #{session[:ratings].inspect}")
    logger.debug("Params: #{params[:ratings].inspect}")
   
    @sort = params['sort']
    @ratings = params[:ratings]
    @all_ratings = Movie.ratings

    if @ratings.nil?
      if session[:ratings]
        @ratings = session[:ratings]
        session.delete(:ratings)
        @ratings_show = @ratings
        if session[:sort]
          @sort = session[:sort]
          session.delete(:sort)
          redirect_to(:action => 'index', :ratings => @ratings, :sort => @sort)
        else
          redirect_to(:action => 'index', :ratings => @ratings)
        end
      else
        @ratings_show = @all_ratings 
      end
    else
      session[:ratings] = @ratings
      @ratings_show = @ratings
    end
    
    if @sort.nil?
      if session[:sort]
        @sort = session[:sort]
        session.delete(:sort)
        if session[:rating]
          @ratings = session[:ratings]
          session.delete(:ratings)
          @ratings_show = @ratings
          redirect_to(:action => 'index', :ratings => @ratings, :sort => @sort)
        else
          redirect_to(:action => 'index', :sort => @sort)
        end
      end
    else
      session[:sort] = @sort
    end
  

    logger.debug("Session new sort: #{session[:sort].inspect}")
   
    if @ratings.nil? && @sort.nil?
      logger.debug("All nil, rating: #{@ratings.inspect}")
      @movies = Movie.all
    
    elsif @ratings.nil? && !@sort.nil?
 logger.debug("maybe new: #{@sort.inspect}")
      @movies = Movie.find(:all, :order => 'title') if params['sort'] == 'title'
      @movies = Movie.find(:all, :order => 'release_date') if params['sort'] == 'release_date' 
     
    elsif !@ratings.nil? && @sort.nil?
      logger.debug("new: #{@ratings.inspect}")
      @movies = Movie.find_all_by_rating(@ratings.keys)
     
    else
 logger.debug("here?: #{@ratings.inspect} #{@sort.inspect}")
      @movies = Movie.find_all_by_rating(@ratings.keys, :order => 'title') if @sort == 'title'
      @movies = Movie.find_all_by_rating(@ratings.keys, :order => 'release_date') if @sort == 'release_date'
     
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
