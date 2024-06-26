class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show reload_images search cancel_search]
  before_action :set_post, only: %i[edit update destroy delete_image]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes([:user, :bookmarks, :favorites]).with_attached_images.order(created_at: :desc).page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @q = @post.comments.ransack(params[:q])
    @comments = @q.result(distinct: true).includes(:user).with_attached_comment_image.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to post_path(@post), success: t("defaults.message.created", item: Post.model_name.human)
    else
      flash.now[:danger] = t("defaults.message.not_created", item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), success: t("defaults.message.updated", item: Post.model_name.human)
    else
      flash.now[:danger] = t("defaults.message.not_updated", item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    respond_to do |format|
      if params[:redirect_after_delete] == "true"
        format.html { redirect_to posts_path, success: t("defaults.message.deleted", item: Post.model_name.human), status: :see_other }
      else
        format.turbo_stream { flash.now[:success] = t("defaults.message.deleted", item: Post.model_name.human) }
      end
    end
  end

  def delete_image
    image = @post.images.find(params[:image_id])
    image.purge
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("attachment_#{image.id}") }
      format.html { redirect_to edit_post_path(@post) }
    end
  end

  def reload_images
    @post = Post.find(params[:id])
    redirect_to post_path(@post), success: t("defaults.message.updated", item: Post.human_attribute_name(:images))
  end

  def search
    @q = Post.ransack(params[:q])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("post_change_form", partial: "shared/posts_search", locals: { q: @q, url: posts_path }) }
      format.html {  }
    end
  end

  def cancel_search
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("post_change_form", partial: "posts/post_control_panel_part") }
      format.html {  }
    end
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :item_info, :item_category, :item_merit, :item_demerit, images: [])
  end
end
