class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true, length: { maximum: 300 }
  
  scope :best_answer, -> { where(best_answer: true) }
  
  def unmark_best_answer
    update(best_answer: false)
  end
  
  after_create :create_notifications
  private

  def create_notifications
    create_notification_for_post_owner
    create_notification_for_previous_commenters
  end

  def create_notification_for_post_owner
    # 投稿者が自分でない場合に通知を作成
    if self.post.user != self.user
      Notification.create(
        user: self.post.user, # 通知を受け取るユーザー（投稿の作成者）
        notifiable: self, # 通知対象のコメント
        message: "#{self.user.name}さんがあなたの投稿にコメントしました。",
        read: false
      )
    end
  end

  def create_notification_for_previous_commenters
    # 以前にコメントしたユーザーに通知を作成（重複を避けるためにdistinctを使用）
    previous_commenters = self.post.comments.where.not(user: self.user).distinct.pluck(:user_id)
    previous_commenters.each do |user_id|
      Notification.create(
        user_id: user_id, # 通知を受け取るユーザー（以前にコメントしたユーザー）
        notifiable: self, # 通知対象のコメント
        message: "#{self.user.name}さんがコメントした投稿に新しいコメントが付きました。",
        read: false
      )
    end
  end
end
