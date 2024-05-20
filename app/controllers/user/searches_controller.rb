class User::SearchesController < ApplicationController
  

  def genre_search
    @genre = Genre.find(params[:genre_id])
    @genre_id = params[:genre_id]
    @genres = Genre.all
    @posts_all = @genre.posts
    
    @posts = Post.where(genre_id: @genre_id)

    if params[:latest]
      @posts = @posts.order(created_at: :desc)
    elsif params[:old]
      @posts = @posts.order(created_at: :asc)
    elsif params[:star_count]
      @posts = @posts.order(star_count: :desc)
    else
      @posts = @posts.order(created_at: :desc) # デフォルトは新しい順
    end

    @posts = @posts.page(params[:page]).per(12)
  end


  def search
    @genres = Genre.all
    @keyword = params[:keyword]
    @results = Post.search_for(@keyword)
    @posts = @results
    render 'user/searches/search'
  end

end