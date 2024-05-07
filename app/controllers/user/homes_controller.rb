class User::HomesController < ApplicationController
  def top
    @genres = Genre.all
    @posts = Post.all.order(created_at: :desc).first(4)
  end

  def about
  end
end
