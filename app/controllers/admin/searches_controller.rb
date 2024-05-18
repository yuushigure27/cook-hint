class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @keyword = params[:keyword]
    @type = params[:search_obj]
    if @type == "posts"
      @results = Post.search_for(@keyword).page(params[:page])
    else
      @results = User.search_for(@keyword).page(params[:page])
    end
  end

end