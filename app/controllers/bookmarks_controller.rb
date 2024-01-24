class BookmarksController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    current_user.bookmark(@post)
    respond_to do |format|
      format.turbo_stream { flash.now[:success] = t(".success") }
      format.html { redirect_back fallback_location: posts_path, success: t(".success") }
    end
  end

  def destroy
    @post = current_user.bookmarks.find(params[:id]).post
    current_user.unbookmark(@post)
    @bookmark_posts = current_user.bookmark_posts.includes([:user, :bookmarks]).with_attached_images.order(created_at: :desc)
    respond_to do |format|
      format.turbo_stream { flash.now[:success] = t(".success") }
      format.html { redirect_back fallback_location: posts_path, success: t(".success") }
    end
  end
end
