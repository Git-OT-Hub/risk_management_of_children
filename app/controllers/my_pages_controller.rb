class MyPagesController < ApplicationController
  def show
  end

  def edit
  end

  def update
  end

  def my_posts
    @my_posts = current_user.posts.includes([:user, :bookmarks, :favorites]).with_attached_images.order(created_at: :desc).page(params[:page]).per(6)
  end

  def bookmarks
    @bookmark_posts = current_user.bookmark_posts.includes([:user, :bookmarks, :favorites]).with_attached_images.order(created_at: :desc).page(params[:page]).per(6)
  end
end
