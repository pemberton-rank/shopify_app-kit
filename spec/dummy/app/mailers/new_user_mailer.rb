class NewUserMailer < ApplicationMailer
  default from: '"Blimpon" <hello@blimpon.com>'

  def welcome(user)
    subject = 'Welcome to Blimpon'
    mail subject: subject, to: user.email
  end

  def new_password(user)
    subject = 'Create a new password'
    mail subject: subject, to: user.email
  end

  def confirm(user)
    subject = 'Create a new password'
    mail subject: subject, to: user.email
  end
end
