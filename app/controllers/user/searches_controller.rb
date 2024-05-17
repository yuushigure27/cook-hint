class User::SearchesController < ApplicationController
  
  
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    
    # 選択したモデルに応じて検索を実行
    if @model  == "user"
      @records = User.search_for(@content, @method)
    else
      @records = Posts.search_for(@content, @method)
    end
  end

  def genre_search
    @genre = Genre.find(params[:genre_id])
    @genre_id = params[:genre_id]
    @posts = Post.where(genre_id: @genre_id).page(params[:page]).per(9) 
    @genres = Genre.all
  end

  def search
    @genres = Genre.all
    @keyword = params[:keyword]
    @results_all = Post.search_for(@keyword)
    @results = @results_all.page(params[:page])
  end

end