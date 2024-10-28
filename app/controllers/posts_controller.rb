# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]

  # List all posts
  def index
    @posts = Post.order(created_at: :desc).includes(:user, :comments)
  end

  # Show a single post
  def show
    @comment = Comment.new
  rescue ActiveRecord::RecordNotFound
    render plain: "404 Not Found", status: :not_found
  end

  # Display new post form
  def new
    @post = Post.new
  end

  # Create a new post
  def create
    @post = Post.new(post_params)
    @post.user_id = session[:user_id]

    if @post.save
      redirect_to @post, notice: "Post created successfully."
    else
      render :new
    end
  end

  # Display edit form (only if the author)
  def edit
  end

  # Update a post (only if the author)
  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post updated successfully."
    else
      render :edit
    end
  end

  # Delete a post (only if the author)
  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post deleted successfully."
  end

  private

  # Strong parameters to prevent mass assignment
  def post_params
    params.require(:post).permit(:title, :content)
  end

  # Find the post based on ID
  def set_post
    @post = Post.find(params[:id])
  end

  # Ensure only the author can edit or delete a post
  def authorize_user
    unless @post.user_id == session[:user_id]
      redirect_to posts_path, alert: "You are not authorized to perform this action."
    end
  end
end

