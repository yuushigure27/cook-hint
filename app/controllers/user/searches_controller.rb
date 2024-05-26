class User::SearchesController < ApplicationController
  

  def genre_search
    @genre = Genre.find(params[:genre_id])
    @genre_id = params[:genre_id]
    @posts = Post.where(genre_id: @genre_id).page(params[:page]).per(12) 
    @genres = Genre.left_joins(:posts).group(:id).order('COUNT(posts.id) DESC')
    @posts_all = @genre.posts
    
    @posts = Post.where(genre_id: @genre_id)

    if params[:latest]
      @posts = @posts.latest.page(params[:page]).per(12)
    elsif params[:old]
      @posts = @posts.old.page(params[:page]).per(12)
    elsif params[:most_liked]
      @posts = Kaminari.paginate_array(@posts.most_liked).page(params[:page]).per(12)
    else
      @posts = @posts.latest.page(params[:page]).per(12)
    end

  end

  def search
    @genres = Genre.all
    @keyword = params[:keyword]
  
    if @keyword.present?
      @results = Post.search_for(@keyword).order(created_at: :desc)
      @posts = @results
    else
      @posts = Post.none
    end
  
    render 'user/searches/search'
  end

end