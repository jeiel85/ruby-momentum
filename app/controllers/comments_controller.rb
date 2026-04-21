class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [ :create ]
  before_action :set_post


  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment added!" }
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, alert: @comment.errors.full_messages.join(", ") }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end