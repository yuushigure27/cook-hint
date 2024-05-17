class SearchesController < ApplicationController

  def search
    @range = params[:range]

    if @range == "ユーザー"
      users = User.looks(params[:search], params[:word])
      @users = users.page(params[:page]).per(10)  
      render template: "admin/users/index"
    else
      posts = Post.looks(params[:search], params[:word])
      @posts = posts.page(params[:page]).per(9)
      @posts_count = posts.count
      if admin_signed_in?
        render template: "admin/posts/index"
      else
        @genres = Genre.all
        render template: "user/posts/index"
      end
    end
  end

end