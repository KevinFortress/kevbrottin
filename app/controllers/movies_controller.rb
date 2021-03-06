class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve a movie ID from the URI route
    @movie = Movie.find(id) # look up a movie by a unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    if params[:sort]
      session[:sort] = params[:sort]
      @movies = Movie.all.order(session[:sort])
    elsif session[:sort]
      @movies = Movie.all.order(session[:sort])
    else
      @movies = Movie.all
    end
    
    @all_ratings = Movie.ratings
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
      @selected_retings = session[:ratings].keys
    elsif session[:ratings]
      @selected_retings = session[:ratings].keys
    else
      @selected_retings = @all_ratings
    end
    
    @movies =  @movies.where(:rating => @selected_retings)
  end
  
  def new
    # default: render the 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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