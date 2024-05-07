class User::SearchesController < ApplicationController


  def genre_search
    @genre = Genre.find(params[:genre_id])
    @genre_id = params[:genre_id]
    @posts = Post.where(genre_id: @genre_id).page(params[:page]).per(10) 
    @genres = Genre.all
  end

  def search
    @genres = Genre.all
    @keyword = params[:keyword]
    @results_all = Post.search_for(@keyword)
    @results = @results_all.page(params[:page])
  end

end