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
  end

  def new
  end
end
