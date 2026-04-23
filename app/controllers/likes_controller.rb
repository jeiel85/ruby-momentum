class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.build(user: current_user)

    if @like.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path, notice: "Liked!" }
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path, alert: "Could not like post" }
      end
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @like = @post.likes.find_by(user: current_user)

    if @like&.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path, notice: "Unliked!" }
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path, alert: "Could not unlike post" }
      end
    end
  end
end
