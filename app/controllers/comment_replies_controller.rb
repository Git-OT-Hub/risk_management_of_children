class CommentRepliesController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  before_action :set_comment, only: %i[index new]
  #before_action :set_comment_reply, only: %i[edit update destroy]

  def index
    @comment_replies = @comment.comment_replies.all
  end

  def new
    #binding.pry
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end
end
