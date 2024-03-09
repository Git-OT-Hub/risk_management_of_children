class CommentRepliesController < ApplicationController
  before_action :set_comment, only: %i[index new cancel_new]
  #before_action :set_comment_reply, only: %i[edit update destroy]

  def index
    @comment_replies = @comment.comment_replies.all
  end

  def new
    @comment_reply = CommentReply.new
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("new_comment_reply", partial: "form", locals: { comment: @comment, comment_reply: @comment_reply }) }
      format.html {  }
    end
    #binding.pry
  end

  def cancel_new
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("new_comment_reply", partial: "comment_reply_button", locals: { comment: @comment }) }
      format.html {  }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end
end
