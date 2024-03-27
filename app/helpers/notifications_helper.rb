module NotificationsHelper

  def generate_notification_message(notification)
    return unless notification
    
    case notification.action
    when "comment_to_post"
      link_to("<span>#{notification.sender.name[0, 10]}</span> があなたの <span>投稿</span> - <span>#{notifiable_name(notification)}</span> にコメントしました".html_safe, 
      post_path(notification.notifiable.post), data: { turbo: false }, class: "link-secondary link-offset-2 link-offset-2-hover link-underline link-underline-opacity-0 link-underline-opacity-75-hover")
    when "reply_to_comment"
      link_to("<span>#{notification.sender.name[0, 10]}</span> があなたの <span>コメント</span> - <span>#{notifiable_name(notification)}</span> に返信しました".html_safe, 
      comment_comment_replies_path(notification.notifiable.comment), data: { turbo: false }, class: "link-secondary link-offset-2 link-offset-2-hover link-underline link-underline-opacity-0 link-underline-opacity-75-hover")
    when "reply_to_comment_reply"
      link_to("<span>#{notification.sender.name[0, 10]}</span> があなたの <span>コメント返信</span> - <span>#{notifiable_name(notification)}</span> に返信しました".html_safe, 
      comment_comment_replies_path(notification.notifiable.comment), data: { turbo: false }, class: "link-secondary link-offset-2 link-offset-2-hover link-underline link-underline-opacity-0 link-underline-opacity-75-hover")
    else
      "新規通知がありました"
    end
  end

  def generate_notification_message_reply(notification)
    return unless notification
    
    case notification.action
    when "comment_to_post"
      "<span>#{notification.sender.name[0, 10]}</span> があなたの <span>投稿</span> - <span>#{notifiable_name(notification)}</span> にコメントしました".html_safe
    when "reply_to_comment"
      "<span>#{notification.sender.name[0, 10]}</span> があなたの <span>コメント</span> - <span>#{notifiable_name(notification)}</span> に返信しました".html_safe
    when "reply_to_comment_reply"
      "<span>#{notification.sender.name[0, 10]}</span> があなたの <span>コメント返信</span> - <span>#{notifiable_name(notification)}</span> に返信しました".html_safe
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
