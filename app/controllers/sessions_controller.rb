# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  # Display login form
  def new
  end

  # Handle login submission
  def create
    user = User.find_or_create_by(username: params[:username])
    session[:user_id] = user.id # Store user ID in the session
    redirect_to root_path # Redirect to the root path 
  end

  # Handle logout and clear the session
  def destroy
    session.delete(:user_id) # Correctly clear the user session
    redirect_to login_path # Redirect to login page
  end

  # Render welcome page or redirect if not logged in
  def welcome
    if session[:user_id].nil?
      redirect_to login_path # Redirect if not logged in
    else
      user = User.find(session[:user_id]) # Fetch the logged-in user
      render plain: "Welcome, #{user.username}!" # Display a welcome message
    end
  end
end


