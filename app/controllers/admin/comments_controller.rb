class Admin::CommentsController < ApplicationController
  before_action :check_guest_user, only: [:create]
  

  
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    if @comment.best_answer
      @comment.update(best_answer: false)
    end

    @comment.destroy
    redirect_to admin_post_path(@post), notice: "コメントを削除しました。"
  end


  private

  def comment_params
     params.require(:comment).permit(:content)
  end
  
 
end
