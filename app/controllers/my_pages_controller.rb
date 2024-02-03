class MyPagesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def show; end

  def edit; end

  def update
    if @user.update(user_update_params)
      redirect_to my_page_path, success: t("defaults.message.updated", item: User.model_name.human)
    else
      flash.now[:danger] = t("defaults.message.not_updated", item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def my_posts
    @q = current_user.posts.ransack(params[:q])
    @my_posts = @q.result(distinct: true).includes([:user, :bookmarks, :favorites]).with_attached_images.order(created_at: :desc).page(params[:page]).per(6)
  end

  def bookmarks
    @q = current_user.bookmark_posts.ransack(params[:q])
    @bookmark_posts = @q.result(distinct: true).includes([:user, :bookmarks, :favorites]).with_attached_images.order(created_at: :desc).page(params[:page]).per(6)
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_update_params
    params.require(:user).permit(:name, :email, :avatar)
  end
end