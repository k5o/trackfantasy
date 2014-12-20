class User < ActiveRecord::Base
  EMAIL_REGEXP = /\S+@\S+/

  validates_presence_of :email, :password
  validates_uniqueness_of :email
  validates_confirmation_of :password
  validates :email, format: { with: EMAIL_REGEXP }
  validates :password, :length => { minimum: 5 }

  has_secure_password
end