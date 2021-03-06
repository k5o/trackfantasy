class User < ActiveRecord::Base
  has_many :accounts
  has_many :entries
  has_many :events

  EMAIL_REGEXP = /\S+@\S+/

  has_secure_password
  validates_presence_of :email
  validates_uniqueness_of :email
  validates :email, format: { with: EMAIL_REGEXP }
  validates :password, length: { minimum: 5 }

  def generate_reset_password_token!
    self.reset_password_token = "#{email.parameterize}-#{SecureRandom.hex(8)}"
    self.save(validate: false)
  end

  def clear_reset_password_token!
    self.reset_password_token = nil
    self.save(validate: false)
  end

  def sports_played
    @sports_played ||= entries.pluck(:sport).uniq
  end

  def empty_entries?
    @empty_entries ||= !entries.exists?
  end
end
