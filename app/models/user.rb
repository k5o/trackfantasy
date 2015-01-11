include BCrypt
class User < ActiveRecord::Base
  has_many :accounts
  has_many :entries

  EMAIL_REGEXP = /\S+@\S+/

  has_secure_password
  # TODO: These validations don't currently work
  # validates_presence_of :email, :password
  # validates_uniqueness_of :email
  # validates :email, format: { with: EMAIL_REGEXP }
  # validates :password, length: { minimum: 5 }

  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end
end
