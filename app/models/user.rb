class User < ActiveRecord::Base

  has_many :accounts
  has_many :entries

  EMAIL_REGEXP = /\S+@\S+/
  STATUSES = { uninitiated: 0, active: 1, inactive: 2 }

  has_secure_password
  validates_presence_of :email, :password
  validates_uniqueness_of :email
  validates :email, format: { with: EMAIL_REGEXP }
  validates :password, length: { minimum: 5 }

  def uninitiated?
    status == STATUSES[:uninitiated]
  end

  def active?
    status == STATUSES[:active]
  end

  def inactive?
    status = STATUSES[:inactive]
  end
end
