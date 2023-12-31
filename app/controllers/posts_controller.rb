class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = Post.all.includes(:user).with_attached_images.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
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

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post was successfully destroyed."
  end

  def delete_image
    @post = Post.find(params[:id])
    image = @post.images.find(params[:image_id])
    image.purge
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(image) }
    end
    #delete_image_post_path(post, image)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, images: [])
  end
end
