class User < ActiveRecord::Base

  has_many :accounts
  has_many :entries, through: :accounts
  has_many :date_stats

  EMAIL_REGEXP = /\S+@\S+/

  has_secure_password
  validates_presence_of :email, :password
  validates_uniqueness_of :email
  validates :email, format: { with: EMAIL_REGEXP }
  validates :password, length: { minimum: 5 }

  def uninitiated?
    !!stripe_customer_id
  end

  def active?
    Time.current <= active_until
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

  def stats_between start_date, end_date
    date_stats.where('date > ? and date < ?', start_date, end_date).map{|ds| [ds.date, ds.stat_hash["total_in_cents"]] }
  end
end
