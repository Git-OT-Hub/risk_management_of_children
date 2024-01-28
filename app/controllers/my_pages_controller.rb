class MyPagesController < ApplicationController
  def show
  end

  def edit
  end

  def update
  end

  def my_posts
    @my_posts = current_user.posts.includes([:user, :bookmarks, :favorites]).with_attached_images.order(created_at: :desc)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("my_page_item_list", partial: "my_posts_list", locals: { my_posts: @my_posts }) }
      format.html {  }
    end
  end

  def bookmarks
    @bookmark_posts = current_user.bookmark_posts.includes([:user, :bookmarks, :favorites]).with_attached_images.order(created_at: :desc)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("my_page_item_list", partial: "bookmarks_list", locals: { bookmark_posts: @bookmark_posts }) }
      format.html {  }
    end
  end
end
