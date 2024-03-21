module NotificationsHelper

  def generate_notification_message(notification)
    return unless notification
    
    case notification.action
    when "comment_to_post"
      link_to("<strong>#{notification.sender.name[0, 10]}</strong> があなたの <strong>投稿</strong> - <strong>#{notifiable_name(notification)}</strong> にコメントしました".html_safe, 
      post_path(notification.notifiable.post), data: { turbo: false }, class: "link-secondary link-offset-2 link-offset-2-hover link-underline link-underline-opacity-0 link-underline-opacity-75-hover")
    when "reply_to_comment"
      link_to("<strong>#{notification.sender.name[0, 10]}</strong> があなたの <strong>コメント</strong> - <strong>#{notifiable_name(notification)}</strong> に返信しました".html_safe, 
      comment_comment_replies_path(notification.notifiable.comment), data: { turbo: false }, class: "link-secondary link-offset-2 link-offset-2-hover link-underline link-underline-opacity-0 link-underline-opacity-75-hover")
    when "reply_to_comment_reply"
      link_to("<strong>#{notification.sender.name[0, 10]}</strong> があなたの <strong>コメント返信</strong> - <strong>#{notifiable_name(notification)}</strong> に返信しました".html_safe, 
      comment_comment_replies_path(notification.notifiable.comment), data: { turbo: false }, class: "link-secondary link-offset-2 link-offset-2-hover link-underline link-underline-opacity-0 link-underline-opacity-75-hover")
    else
      "新規通知がありました"
    end
  end

  def generate_notification_message_reply(notification)
    return unless notification
    
    case notification.action
    when "comment_to_post"
      "<strong>#{notification.sender.name[0, 10]}</strong> があなたの <strong>投稿</strong> - <strong>#{notifiable_name(notification)}</strong> にコメントしました".html_safe
    when "reply_to_comment"
      "<strong>#{notification.sender.name[0, 10]}</strong> があなたの <strong>コメント</strong> - <strong>#{notifiable_name(notification)}</strong> に返信しました".html_safe
    when "reply_to_comment_reply"
      "<strong>#{notification.sender.name[0, 10]}</strong> があなたの <strong>コメント返信</strong> - <strong>#{notifiable_name(notification)}</strong> に返信しました".html_safe
    else
      "新規通知がありました"
    end
  end

  private

  def notifiable_name(notification)
    return unless notification && notification.notifiable

    case notification.action
    when "comment_to_post"
      "#{notification.notifiable.post.title[0, 10]}"
    when "reply_to_comment"
      "#{notification.notifiable.comment.body[0, 10]}"
    when "reply_to_comment_reply"
      "#{notification.notifiable.parent.body[0, 10]}"
    else
      "新規通知がありました"
    end
  end
end
