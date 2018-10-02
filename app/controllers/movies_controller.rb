class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.all_ratings
  
    sort_choice = params[:sort]
   
    if params[:ratings] == nil
      if session[:ratings] == nil
        @selected_ratings = @all_ratings
        session[:ratings] = @selected_ratings
      else
        @selected_ratings = session[:ratings]
      end
    else
      @selected_ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    end
    
    if params[:sort] == nil
      if session[:sort] == nil
        sort_choice = Movie.all
        session[:sort] = sort_choice
      else
        sort_choice = session[:sort]
      end
    else
      sort_choice = params[:sort]
      session[:sort] = params[:sort]
    end
    
  
    
    if sort_choice == 'title'
      @title_header = 'hilite'
      @movies =  Movie.where(:rating => @selected_ratings.keys).order(title: :asc)
    elsif sort_choice == 'release_date'
        @release_header = 'hilite'
        @movies =  Movie.where(:rating => @selected_ratings.keys).order(release_date: :asc)
    end
  end

  
  def new
    # default: render 'new' template
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
