class CommentRepliesController < ApplicationController
  before_action :set_comment, only: %i[index new cancel_new create]
  before_action :set_comment_reply, only: %i[edit update destroy cancel_edit]

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
      @comment_reply.broadcast_append_to("comment_replies_list", target: "comment_replies_comment_#{@comment.id}", partial: "comment_replies/comment_reply_frame", locals: { comment_reply: @comment_reply })
      respond_to do |format|
        format.turbo_stream do
          flash.now[:success] = t("defaults.message.created", item: CommentReply.model_name.human)
          render turbo_stream: [
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

  def show
    @comment_reply = CommentReply.find(params[:id])
    @comment = @comment_reply.comment
    if request.headers["turbo-frame"]
      render partial: "comment_replies/comment_reply", locals: { comment_reply: @comment_reply }
    else
      redirect_to comment_comment_replies_path(@comment)
    end
  end

  def edit
    @comment = @comment_reply.comment
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("new_comment_reply", partial: "form", locals: { comment: @comment, comment_reply: @comment_reply }),
          turbo_stream.replace("comment_reply_#{@comment_reply.id}", partial: "while_editing", locals: { comment_reply: @comment_reply })
        ]
      end
      format.html {  }
    end
  end

  def cancel_edit
    @comment = @comment_reply.comment
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("new_comment_reply", partial: "comment_reply_button", locals: { comment: @comment }),
          turbo_stream.replace("comment_reply_#{@comment_reply.id}", partial: "comment_reply", locals: { comment_reply: @comment_reply })
        ]
      end
      format.html {  }
    end
  end

  def update
  end

  def destroy
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end

  def set_comment_reply
    @comment_reply = CommentReply.find(params[:id])
  end

  def comment_reply_params
    params.require(:comment_reply).permit(:body, :comment_reply_image).merge(comment_id: params[:comment_id])
  end
end
