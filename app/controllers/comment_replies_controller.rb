class CommentRepliesController < ApplicationController
  #before_action :set_comment_reply, only: %i[edit update destroy]

  def index
    @comment = Comment.find(params[:comment_id])
    #binding.pry
  end
end
