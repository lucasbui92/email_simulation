# frozen_string_literal: true

class Emails::MoveToTrashService < ApplicationService
  def initialize(email_id:, user:)
    @email_id = email_id
    @user = user
  end

  def call
    @email = @user.sent_status_emails.find(@email_id)
    @email.is_deleted = true
    @email.save
  end
end
