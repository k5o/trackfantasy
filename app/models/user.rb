class User < ActiveRecord::Base
  has_many :accounts
  has_many :entries

  EMAIL_REGEXP = /\S+@\S+/

  has_secure_password
  validates_presence_of :email
  validates_uniqueness_of :email
  validates :email, format: { with: EMAIL_REGEXP }
  validates :password, length: { minimum: 5 }
end
