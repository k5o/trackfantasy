class LandingController < ApplicationController
  def index
    redirect_to dashboard_path if current_user && !current_user.uninitiated?
  end

  def privacy
  end
end