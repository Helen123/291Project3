# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user_id = session[:user_id]

    if @comment.save
      redirect_to post_path(@post), notice: "Comment added!"
    else
      flash.now[:alert] = "Failed to add comment."
      render "posts/show", locals: { post: @post, comment: @comment }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end

