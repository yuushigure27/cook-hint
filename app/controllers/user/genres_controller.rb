class User::GenresController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @genre = Genre.new
  end
  
  def index
    @genre = Genre.new
    @genres = Genre.all
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      if request.referer == new_post_url
        flash[:notice] = "ジャンルの作成に成功しました"
        redirect_to request.referer
      else
        redirect_to genres_path
      end
    else
      @genres = Genre.all
      render 'index'
    end  
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to genres_path, notice: "変更を保存しました。"
    else
      render 'edit'
    end  
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end

  def init_sidebar
    @posts = Post.where(is_active: true)
    @genres = Genre.all
  end

end
