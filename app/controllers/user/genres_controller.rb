class User::GenresController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @genre = Genre.new
  end
  
  def index
    @genre = Genre.new
    @genres = case params[:sort]
              when 'posts_count'
                Genre.left_joins(:posts).group(:id).order('COUNT(posts.id) DESC')
              when 'name'
                Genre.order(:name)
              else
                Genre.all
              end
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      render json: { id: @genre.id, name: @genre.name }
    else
      render json: { errors: @genre.errors.full_messages }, status: :unprocessable_entity
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
