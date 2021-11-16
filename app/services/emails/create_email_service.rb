# frozen_string_literal: true

class Emails::CreateEmailService < ApplicationService
  def initialize(commit:, email_params:, user:)
    @commit = commit
    @email_params = email_params
    @user = user
  end

  def call
    if @commit == Email::SAVE_DRAFT
      return true if @user.draft_status_emails.new(@email_params).save
    else
      return true if @user.sent_status_emails.new(@email_params).save
    end
    raise StandardError, 'Not all fields filled in completely!'
  end
end
