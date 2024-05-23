class User::CommentsController < ApplicationController
  #before_action :check_guest_user, only: [:create]
  
def create
  @post = Post.find(params[:post_id])
  @comment = @post.comments.build(comment_params)
  @comment.user_id = current_user.id
  @comment.save

  # if @comment.save
  #   redirect_to post_path(@post), notice: 'コメントが投稿されました。'
  # else
  #   redirect_to post_path(@post), alert: 'コメントの投稿に失敗しました。'
  # end
end

  
  def edit
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.update(comment_params)
    # if @comment.update(comment_params)
    #   redirect_to post_path(@post), notice: 'コメントが更新されました'
    # else
    #   render :edit
    # end
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.js
    end
    # redirect_to post_path(@post), notice: 'コメントが削除されました'
  end


  private

  def comment_params
     params.require(:comment).permit(:content)
  end
  
  # def check_guest_user
  #   @post = Post.find(params[:post_id])
  #   if current_user.email == "guest@example.com"
  #     redirect_to post_path(@post), alert: "ゲストユーザーはコメントできません。"
  #   end
  # end
end
