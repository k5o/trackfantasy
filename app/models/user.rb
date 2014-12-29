class User < ActiveRecord::Base

  has_many :accounts
  has_many :entries

  EMAIL_REGEXP = /\S+@\S+/

  has_secure_password
  # validates_presence_of :email, :password
  # validates_uniqueness_of :email
  # validates :email, format: { with: EMAIL_REGEXP }
  # validates :password, length: { minimum: 5 }

  def uninitiated?
    stripe_customer_id.nil?
  end

  def active?
    active_until && Time.current <= active_until
  end

  def inactive?
    !!active_until || Time.current >= active_until
  end

  def set_active_until!(plan)
    return unless plan

    if plan.name == PaymentPlan::MONTHLY_PLAN_NAME
      self.active_until = 1.month.from_now
    elsif plan.name == PaymentPlan::ANNUAL_PLAN_NAME
      self.active_until = 1.year.from_now
    end

    self.save!
  end
end
