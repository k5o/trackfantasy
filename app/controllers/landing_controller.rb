class LandingController < ApplicationController
  before_filter :no_layout, only: :payment

  def index
  end

  def payment
  end
end