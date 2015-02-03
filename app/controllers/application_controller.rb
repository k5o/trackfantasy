class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  helper_method :current_user
  helper_method :beta

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def no_layout
    @no_layout = true
  end

  def fetch_analytics
    @analytics ||= Dashboard::AnalyticsCalculator.new(view_context)
  end

  def store_event!(event_name)
    ua = UserAgent.parse(request.env["HTTP_USER_AGENT"])
    event = Event.new

    event.name = event_name
    event.browser = ua.browser
    event.browser_version = ua.version
    event.platform = ua.platform
    event.ip_address = request.remote_ip
    event.user = current_user if current_user

    event.save
  end

  def beta
    true
  end
end
