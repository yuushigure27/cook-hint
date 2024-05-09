class User::HomesController < ApplicationController
  def top
    @genres = Genre.all
    @posts = Post.order(created_at: :desc).limit(9)
  end

  def about
  end
end
