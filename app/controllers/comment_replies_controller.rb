class CommentRepliesController < ApplicationController
  before_action :set_comment, only: %i[index new cancel_new create]
  #before_action :set_comment_reply, only: %i[edit update destroy]

  def index
    @q = @comment.comment_replies.ransack(params[:q])
    @comment_replies = @q.result(distinct: true).includes(:user).with_attached_comment_reply_image.order(created_at: :asc)
  end

  def new
    @comment_reply = CommentReply.new
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("new_comment_reply", partial: "form", locals: { comment: @comment, comment_reply: @comment_reply }) }
      format.html {  }
    end
  end

  def cancel_new
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("new_comment_reply", partial: "comment_reply_button", locals: { comment: @comment }) }
      format.html {  }
    end
  end

  def create
    @comment_reply = current_user.comment_replies.build(comment_reply_params)
    if @comment_reply.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:success] = t("defaults.message.created", item: CommentReply.model_name.human)
          render turbo_stream: [
            turbo_stream.append("comment_replies_comment_#{@comment.id}", partial: "comment_reply", locals: { comment_reply: @comment_reply }),
            turbo_stream.replace("new_comment_reply", partial: "comment_reply_button", locals: { comment: @comment }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html {  }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:danger] = t("defaults.message.not_created", item: CommentReply.model_name.human)
          render turbo_stream: [
            turbo_stream.replace("new_comment_reply", partial: "form", locals: { comment: @comment, comment_reply: @comment_reply }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html {  }
      end
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end

  def comment_reply_params
    params.require(:comment_reply).permit(:body, :comment_reply_image).merge(comment_id: params[:comment_id])
  end
end
