class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  
  
  def deletemovies
     
     @all_ratings = Movie.all_ratings
     
     
     if params[:ratings] != nil
      @movies = Movie.where(:rating => [params[:ratings].keys])
      
        if @movies
            @movies.each do |movie|
            movie.destroy
           end
           flash[:notice] = "Movies with ratings: #{params[:ratings].keys} deleted."
           
        end
        
      
     end
     
     
     
     
     if params[:Entringmovie] != nil
      
      @movie = Movie.find_by_title(params[:Entringmovie].values)
      
           if @movie
           @movie.destroy
           flash[:notice] = "Movie '#{@movie.title}' deleted."
           
           end
           
      
    
     
     end
     
    
    
    
  end
  
  
  
  def updates
   
   
  sessions = 0

    if params[:EnteredMovie] != nil
    
    # @kuta = Movie.where(:title => [params[:EnteredMovie].values])
      @movie = Movie.find_by_title(params[:EnteredMovie].values)
      
      
      
      if @movie
          
            if params[:movie].values[0] != ""
                @movie.update_attributes!(:title => params[:movie].values[0])
            end
            if params[:movie].values[1] != ""
                 @movie.update_attributes!(:rating => params[:movie].values[1])
            end
             if params[:movie].values[2] != ""
                 @movie.update_attributes!(:release_date => params[:movie].values[2])
            end
           
        
          flash[:notice] = "Movie Informations Updated "
        
         
  
        
      else
          flash[:notice] = "Erroe: Movie Not Found, Try Again " 
            
  
          
      end
        
        
     sessions = 1
   
 
  end
  
    
    # puts "asdads #{@rizi[rizibest]}"
    if sessions ==1 
    redirect_to movies_path
    end
    
  end
  
  
  
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
     @all_ratings= Movie.all_ratings
     @hash = Hash[*@all_ratings.map{|key| [key,"1"]}.flatten]
     
    if params[:ratings] != nil
      @hash= params[:ratings]
      @movies =  Movie.where(:rating => [@hash.keys])
      session[:ratings] = @hash
    end
    
    if params[:sort_by] != nil
       
        if params[:sort_by] == "title"
      
        @hili = "hilite"
       elsif params[:sort_by] == "release_date"
        @hilii = "hilite"
       end
        
        session[:sort] =  params[:sort_by]
        
         @movies = Movie.all.sort_by { |a| a[params[:sort_by]]} 
    end
     
     
     
     if params[:ratings]== nil && params[:sort_by] == nil
       @movies = Movie.where(:rating => [@hash.keys])
       
     end
    
    if (params[:sort_by] == nil || params[:ratings] == nil)
        if session[:ratings] != nil
          @hash = session[:ratings]
        end
        
      @movies = Movie.where(:rating => [@hash.keys]).all.sort_by { |a| a[params[:sort_by]]} 
    end
      
    
   
  
   
   
    
    
    
  
    #   @all_ratings= Movie.all_ratings
       
    # if params[:ratings] != nil
    #   @hash= params[:ratings]
     
    #   session[:ratings] = @hash
    # else 
    
    
    #   @hash = Hash[*@all_ratings.map{|key| [key,"1"]}.flatten]
    #     if session[:ratings] != nil
    #     @hash = session[:ratings] 
      
    #     end
       
    # end
         
    # if params[:sort_by] == "title"
    #     @hili = "hilite"
    # elsif params[:sort_by] == "release_date"
    #     @hilii = "hilite"
    # end
     
    
    
    # @movies = Movie.where(:rating => [session[:ratings].keys]).all.sort_by { |a| a[params[:sort_by]]} 
   
     
    #   puts "prat #{params[:ratings]}  psort #{params[:sort_by]} srat #{session[:ratings]} ssor #{session[:sort_by]} "
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
