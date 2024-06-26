class Admin::GenresController < ApplicationController
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

  def edit
    @genre = Genre.find(params[:id])
  end
  
  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to admin_genres_path, notice: 'ジャンル名が編集されました'
    else
      render :edit
    end
  end

  def destroy
    @genre = Genre.find(params[:id])
    @genre.destroy
    redirect_to admin_genres_path, notice: 'ジャンルを削除しました。'
  end
  
  def genre_params
    params.require(:genre).permit(:name)
  end
end