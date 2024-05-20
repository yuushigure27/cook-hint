class User::SearchesController < ApplicationController
  

  def genre_search
    @genre = Genre.find(params[:genre_id])
    @genre_id = params[:genre_id]
    @posts = Post.where(genre_id: @genre_id).page(params[:page]).per(12) 
    @genres = Genre.all
    @posts_all = @genre.posts
  end

  def search
    @genres = Genre.all
    @keyword = params[:keyword]
    @results = Post.search_for(@keyword)
    @posts = @results
    render 'user/searches/search'
  end

end