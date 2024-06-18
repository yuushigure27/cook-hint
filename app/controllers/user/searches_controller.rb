class User::SearchesController < ApplicationController
  

  def genre_search
    @genre = Genre.find(params[:genre_id])
    @genre_id = params[:genre_id]
    @posts = Post.where(genre_id: @genre_id).page(params[:page]).per(12) 
    @genres = Genre.left_joins(:posts).group(:id).order('COUNT(posts.id) DESC')
    @posts_all = @genre.posts
    
    @posts = Post.where(genre_id: @genre_id)

    if params[:latest]
      @posts = @genre.posts.latest.page(params[:page]).per(12)
    elsif params[:old]
      @posts = @genre.posts.old.page(params[:page]).per(12)
    elsif params[:most_liked]
      @posts = Kaminari.paginate_array(@genre.posts.most_liked).page(params[:page]).per(12)
    elsif params[:best_answer] == "true"
      @posts = @genre.posts.joins(:comments).where(comments: { best_answer: true }).distinct.page(params[:page]).per(12)
    elsif params[:best_answer] == "false"
      @posts = @genre.posts.where.not(id: Comment.select(:post_id).where(best_answer: true)).order(created_at: :desc).page(params[:page]).per(12)
    else
      @posts = @genre.posts.latest.page(params[:page]).per(12)
    end

  end

  def search
    @genres = case params[:sort]
              when 'name'
                Genre.order(:name)
              else
                Genre.left_joins(:posts).group(:id).order('COUNT(posts.id) DESC')
              end
    @keyword = params[:keyword]
  
    if @keyword.present?
      @results = Post.search_for(@keyword).order(created_at: :desc).page(params[:page]).per(12)
      @results_all = Post.search_for(@keyword)
      @posts = @results
    else
      @results = []
      @results_all = Post.none  # キーワードがない場合に @results_all を空のコレクションに設定
      @posts = Post.none.page(params[:page]).per(12)
    end
  
    render 'user/searches/search'
  end

end