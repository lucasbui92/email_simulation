# frozen_string_literal: true

class MyMailer < ApplicationMailer
  def sending_email(current_user, to, subject, content)
    @content = content
    mail(from: current_user.email, to: to, subject: subject)
  end
end
