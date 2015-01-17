class UserMailerPreview < ActionMailer::Preview
  def reset_password_preview
    UserMailer.reset_password_email(User.find_by_email("enhasa@gmail.com"))
  end

  def user_feedback_preview
    UserMailer.user_feedback_email(User.find_by_email("enhasa@gmail.com"), "i am\n\nthe best")
  end
end