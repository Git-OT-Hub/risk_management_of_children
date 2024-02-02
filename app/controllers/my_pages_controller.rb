class MyPagesController < ApplicationController
  def show
  end

  def edit
  end

  def update
  end

  def my_posts
    @q = current_user.posts.ransack(params[:q])
    @my_posts = @q.result(distinct: true).includes([:user, :bookmarks, :favorites]).with_attached_images.order(created_at: :desc).page(params[:page]).per(6)
  end

  def bookmarks
    @q = current_user.bookmark_posts.ransack(params[:q])
    @bookmark_posts = @q.result(distinct: true).includes([:user, :bookmarks, :favorites]).with_attached_images.order(created_at: :desc).page(params[:page]).per(6)
  end
end
