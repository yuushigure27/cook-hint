class User::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user, only: [:create]
  before_action :set_post
  before_action :set_comment, only: [:destroy, :edit, :update, :mark_best_answer, :unmark_best_answer]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  
  
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      @post.create_notification_by(current_user)
      respond_to do |format|
        format.html { redirect_to @post, notice: 'コメントが追加されました。' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'posts/show', alert: 'コメントの追加に失敗しました。' }
        format.js { render 'error.js.erb' }
      end
    end
  end
  
  def edit
  end
  
  def update
    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: 'コメントが更新されました'
    else
      render :edit
    end
  end
  
  def destroy
    @comment.destroy
    respond_to do |format|
      format.js
    end
  end

  def mark_best_answer
    @post.comments.update_all(best_answer: false) # 既存のベストアンサーを解除
    @comment.update(best_answer: true)
    redirect_to @post, notice: 'ベストアンサーを設定しました。'
  end

  def unmark_best_answer
    @comment.update(best_answer: false)
    redirect_to @post, notice: 'ベストアンサーを解除しました。'
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
  
  def check_guest_user
    if current_user.email == "guest@example.com"
      redirect_to post_path(@post), alert: "ゲストユーザーはコメントできません。"
    end
  end
  
  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def authorize_user
    unless current_user == @comment.user
      redirect_to post_path(@post), alert: '他のユーザーのコメントを操作する権限がありません。'
    end
  end
end
