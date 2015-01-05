class DashboardController < ApplicationController
  before_filter :verify_user
  before_filter :load_params
  # caches_action :fetch_dashboard_data, expires_in: 1.month # TODO: invalidate cache when new csv is imported

  def index
  end

  def fetch_dashboard_data
    # TODO: Ensure request/return are clean, email notify admins if not (exception email)
    begin
      @analytics = Dashboard::AnalyticsCalculator.new(@user, @date_range, @site, @sport)
    rescue
      render :index, status: 403 and return
    end

    if request.xhr?
      render 'presenter.js'
    else
      redirect_to dashboard_path(from_date: @date_range.first, to_date: @date_range.last, site: @site, sport: @sport)
    end
  end

  private

  def verify_user
    redirect_to root_path unless current_user && !current_user.uninitiated?

    @user = current_user
  end

  def load_params
    @date_range = params[:from_date]..params[:to_date]
    @site = params[:site]
    @sport = params[:sport]
  end
end