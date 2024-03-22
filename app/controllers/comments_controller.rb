class CommentsController < ApplicationController
  skip_before_action :require_login, only: %i[search cancel_search]
  before_action :set_comment, only: %i[edit cancel_edit delete_comment_image update destroy]
  before_action :set_post, only: %i[new cancel_new search cancel_search login_required unread cancel_unread]

  def new
    @comment = Comment.new
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("comment_change_form", partial: "form", locals: { post: @post, comment: @comment }) }
      format.html {  }
    end
  end

  def cancel_new
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("comment_change_form", partial: "comment_control_panel_part", locals: { post: @post }) }
      format.html {  }
    end
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @post = @comment.post
    if @comment.save
      respond_to do |format|
        format.turbo_stream { flash.now[:success] = t("defaults.message.created", item: Comment.model_name.human) }
        format.html {  }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:danger] = t("defaults.message.not_created", item: Comment.model_name.human)
          render turbo_stream: [
            turbo_stream.update("comment_change_form", partial: "form", locals: { post: @post, comment: @comment }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html {  }
      end
    end
  end

  def edit
    @post = @comment.post
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("edit_form_comment_#{@comment.id}", partial: "form", locals: { post: @post, comment: @comment }) }
      format.html {  }
    end
  end

  def cancel_edit
    @post = @comment.post
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("comment_#{@comment.id}", partial: "comment", locals: { comment: @comment }) }
      format.html {  }
    end
  end

  def delete_comment_image
    @comment.comment_image.purge
    @post = @comment.post
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("form_comment_#{@comment.id}", partial: "form_part", locals: { post: @post, comment: @comment }) }
      format.html {  }
    end
  end

  def update
    @post = @comment.post
    if @comment.update(comment_update_params)
      respond_to do |format|
        format.turbo_stream { flash.now[:success] = t("defaults.message.updated", item: Comment.model_name.human) }
        format.html {  }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:danger] = t("defaults.message.not_updated", item: Comment.model_name.human)
          render turbo_stream: [
            turbo_stream.update("edit_form_comment_#{@comment.id}", partial: "form", locals: { post: @post, comment: @comment }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html {  }
      end
    end
  end

  def destroy
    @comment.destroy!
    respond_to do |format|
      format.turbo_stream { flash.now[:success] = t("defaults.message.deleted", item: Comment.model_name.human) }
      format.html {  }
    end
  end

  def search
    @q = @post.comments.ransack(params[:q])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("comment_change_form", partial: "shared/comments_search", locals: { q: @q, url: post_path(@post), post: @post }) }
      format.html {  }
    end
  end

  def cancel_search
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("comment_change_form", partial: "comments/comment_control_panel_part", locals: { post: @post }) }
      format.html {  }
    end
  end

  def login_required
    redirect_to post_path(@post)
  end

  def unread
  end

  def cancel_unread
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :comment_image).merge(post_id: params[:post_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body, :comment_image)
  end
end
