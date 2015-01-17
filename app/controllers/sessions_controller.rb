class SessionsController < ApplicationController
  before_filter :no_layout, only: [:new, :create]
  def new
  end

  def create
    @user = User.find_by_email(params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id

      redirect_to dashboard_path
    else
      @invalid_message = "Invalid username/email or password combination"
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end