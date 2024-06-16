class User::CommentsController < ApplicationController
  before_action :check_guest_user, only: [:create]
  before_action :authenticate_user!
  before_action :set_post, only: [:create, :destroy, :mark_best_answer, :unmark_best_answer]
  before_action :set_comment, only: [:destroy, :mark_best_answer, :unmark_best_answer]
  
  def mark_best_answer
    @post.comments.update_all(best_answer: false) # 既存のベストアンサーを解除
    @comment.update(best_answer: true)
    redirect_to @post, notice: 'ベストアンサーを設定しました。'
  end

  def unmark_best_answer
    if @comment
      @comment.update(best_answer: false)
      redirect_to @post, notice: 'ベストアンサーを解除しました。'
    else
      redirect_to @post, alert: 'コメントが見つかりませんでした。'
    end
  end
  
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.page(params[:page]).per(10)
    @comment = Comment.new
  end
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    @post.create_notification_by(current_user)
     
  
    # if @comment.save
    #   redirect_to post_path(@post), notice: 'コメントが投稿されました。'
    # else
    #   redirect_to post_path(@post), alert: 'コメントの投稿に失敗しました。'
    # end
    if @comment.save
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
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    
    unless current_user == @comment.user
      redirect_to post_path(@post), alert: '他のユーザーのコメントを編集する権限がありません。'
    end
  end
  
  def update
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    
    unless current_user == @comment.user
      redirect_to post_path(@post), alert: '他のユーザーのコメントを更新する権限がありません。'
      return
    end
  
    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: 'コメントが更新されました'
    else
      render :edit
    end
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
  
  def check_guest_user
    @post = Post.find(params[:post_id])
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
end