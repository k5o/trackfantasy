class LandingController < ApplicationController
  def index
    redirect_to dashboard_path if current_user
  end

  def privacy
  end
end