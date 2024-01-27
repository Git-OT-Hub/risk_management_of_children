class FavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    current_user.favorite(@post)
    respond_to do |format|
      format.turbo_stream { flash.now[:success] = t(".success") }
      format.html { redirect_back fallback_location: posts_path, success: t(".success") }
    end
  end

  def destroy
    post = current_user.favorites.find(params[:id]).post
    current_user.remove_favorite(post)
    @current_post = Post.find(post.id)
    respond_to do |format|
      format.turbo_stream { flash.now[:success] = t(".success") }
      format.html { redirect_back fallback_location: posts_path, success: t(".success") }
    end
  end
end
