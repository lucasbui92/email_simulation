# frozen_string_literal: true

class Emails::ChangeEmailStatusService < ApplicationService
  attr_reader :email_id, :user

  def initialize(email_id:, user:)
    super(email_id: email_id, user: user)
    @email_id = email_id
    @user = user
  end

  def call
    @user_email = @user.received_emails.find_by(email_id: @email_id)
    @user_email.status = 'read'
    @user_email.save
  end
end
