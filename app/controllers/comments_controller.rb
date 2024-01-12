class CommentsController < ApplicationController

  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("new_comment", partial: "new", locals: { post: @post, comment: @comment }) }
    end
  end

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      respond_to do |format|
        format.turbo_stream {  }
        format.html {  }
      end
    else
    end
  end

  def cancel_new_comment
    @post = Post.find(params[:post_id])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("new_comment", partial: "new_comment_link", locals: { post: @post }) }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end
end
