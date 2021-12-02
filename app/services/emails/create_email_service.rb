# frozen_string_literal: true

class Emails::CreateEmailService < ApplicationService
  def initialize(commit:, email_params:, user:)
    @commit = commit
    @email_params = email_params
    @user = user
  end

  def call
    if @commit == Email::SAVE_DRAFT
      @email = @user.draft_status_emails.create(@email_params)
    else
      @email = @user.sent_status_emails.create(@email_params)
    end
  end
end
