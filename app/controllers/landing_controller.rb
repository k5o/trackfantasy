class LandingController < ApplicationController
  def index
    redirect_to dashboard_path if current_user
    @user = User.new
  end

  def privacy
  end
end