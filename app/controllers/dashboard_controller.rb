class DashboardController < ApplicationController
  before_filter :verify_user
  before_filter :load_params
  # caches_action :fetch_dashboard_data, expires_in: 1.month # TODO: invalidate cache when new csv is imported

  def index
  end

  def fetch_dashboard_data
    # TODO: Ensure request/return are clean, email notify admins if not (exception email)
    @analytics = Dashboard::AnalyticsCalculator.new(@user, @date_range, @site, @sport)

    if @analytics.valid?
      if request.xhr?
        render partial: 'presenter', status: 200 and return
      else
        redirect_to dashboard_path(from_date: @date_range.first, to_date: @date_range.last, site: @site, sport: @sport)
      end
    else
      flash.now[:error] = "Something went wrong, please make sure your date input is valid. <a href='/dashboard'>Refresh</a>".html_safe
      render :index, status: 403 and return
    end
  end

  def support
  end

  private

  def verify_user
    @user = current_user
  end

  def load_params
    @date_range = params[:from_date]..params[:to_date]
    @site = params[:site]
    @sport = params[:sport]
  end
end