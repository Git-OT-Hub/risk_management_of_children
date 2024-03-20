class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_post, only: %i[new search cancel_search login_required]

  def new
    @comment = Comment.new
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("comment_change_form", partial: "form", locals: { post: @post, comment: @comment }) }
      format.html {  }
    end
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @post = @comment.post
    if @comment.save
      respond_to do |format|
        format.turbo_stream { flash.now[:success] = t("defaults.message.created", item: Comment.model_name.human) }
        format.html { redirect_to post_path(@post), success: t("defaults.message.created", item: Comment.model_name.human) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:danger] = t("defaults.message.not_created", item: Comment.model_name.human)
          render turbo_stream: [
            turbo_stream.update("new_comment", partial: "form", locals: { post: @post, comment: @comment }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html do
          flash.now[:danger] = t("defaults.message.not_created", item: Comment.model_name.human)
          render :new, status: :unprocessable_entity
        end
      end
    end
  end

  def edit
    @post = @comment.post
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("comment_#{@comment.id}", partial: "form", locals: { post: @post, comment: @comment }) }
      format.html {  }
    end
  end

  def update
    @post = @comment.post
    if @comment.update(comment_update_params)
      respond_to do |format|
        format.turbo_stream { flash.now[:success] = t("defaults.message.updated", item: Comment.model_name.human) }
        format.html { redirect_to post_path(@post), success: t("defaults.message.updated", item: Comment.model_name.human) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:danger] = t("defaults.message.not_updated", item: Comment.model_name.human)
          render turbo_stream: [
            turbo_stream.update("comment_#{@comment.id}", partial: "form", locals: { post: @post, comment: @comment }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html do
          flash.now[:danger] = t("defaults.message.not_updated", item: Comment.model_name.human)
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @post = @comment.post
    @comment.destroy!
    respond_to do |format|
      format.turbo_stream { flash.now[:success] = t("defaults.message.deleted", item: Comment.model_name.human) }
      format.html { redirect_to post_path(@post), success: t("defaults.message.deleted", item: Comment.model_name.human), status: :see_other }
    end
  end

  def cancel_new_comment
    @post = Post.find(params[:post_id])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("new_comment", partial: "new_comment_link", locals: { post: @post }) }
      format.html { redirect_to post_path(@post) }
    end
  end

  def cancel_edit
    @comment = current_user.comments.find(params[:id])
    @post = @comment.post
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("comment_#{@comment.id}", partial: "comment", locals: { comment: @comment }) }
      format.html { redirect_to post_path(@post) }
    end
  end

  def delete_comment_image
    comment = current_user.comments.find(params[:id])
    comment.comment_image.purge
    @comment_after_purge = current_user.comments.find(params[:id])
    @post = @comment_after_purge.post
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("form_comment_#{@comment_after_purge.id}", partial: "form_part", locals: { post: @post, comment: @comment_after_purge }) }
      format.html { redirect_to edit_comment_path(@comment_after_purge) }
    end
  end

  def login_required
    redirect_to post_path(@post)
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
