class Admin::CommentsController < ApplicationController
  before_action :check_guest_user, only: [:create]

  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
     redirect_to admin_post_path(@post), notice: 'コメントが削除されました'
  end


  private

  def comment_params
     params.require(:comment).permit(:content)
  end
  
 
end
