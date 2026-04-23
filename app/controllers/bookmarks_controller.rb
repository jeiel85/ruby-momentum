class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @bookmark = @post.bookmarks.build(user: current_user)

    if @bookmark.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path, notice: "Bookmarked!" }
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path, alert: "Could not bookmark post" }
      end
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @bookmark = @post.bookmarks.find_by(user: current_user)

    if @bookmark&.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path, notice: "Bookmark removed!" }
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path, alert: "Could not remove bookmark" }
      end
    end
  end
end
