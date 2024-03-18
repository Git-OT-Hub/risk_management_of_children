module NotificationsHelper
  def generate_notification_message(notification)
    return unless notification
    
    case notification.action
    when "Comment"
      "#{notification.sender.name} さんがあなたの <strong>投稿</strong> - <strong>#{notifiable_name(notification)}</strong> にコメントしました".html_safe
    when "reply_to_Comment"
      "#{notification.sender.name} さんがあなたの <strong>コメント</strong> - <strong>#{notifiable_name(notification)}</strong> に返信しました".html_safe
    when "reply_to_Comment_reply"
      "#{notification.sender.name} さんがあなたの <strong>コメント返信</strong> - <strong>#{notifiable_name(notification)}</strong> に返信しました".html_safe
    else
      "新規通知がありました"
    end
  end

  private

  def notifiable_name(notification)
    return unless notification && notification.notifiable

    case notification.action
    when "Comment"
      "#{notification.notifiable.post.title}"
    when "reply_to_Comment"
      "#{notification.notifiable.comment.body[0, 10]}"
    when "reply_to_Comment_reply"
      "#{notification.notifiable.parent.body[0, 10]}"
    else
      "新規通知がありました"
    end
  end
end
