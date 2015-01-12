class UsersController < ApplicationController
  before_filter :no_layout, only: [:new, :create]
  before_filter :load_user, only: [:edit, :update]

  def show
  end

  def new
    redirect_to dashboard_path and return if current_user

    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    new_password = params[:new_password]

    if new_password.present?
      if current_user.password == params[:current_password]
        current_user.password = new_password
        current_user.save
      else
        flash.now[:error] = 'Your password was incorrect.'
        render :edit and return
      end
    end

    flash[:success] = 'Your account has been updated.'
    redirect_to account_path and return
  end

  private

  def user_params
    params.permit(:email, :password)
  end

  def load_user
    @user = current_user
  end
end
