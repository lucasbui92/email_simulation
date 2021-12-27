# frozen_string_literal: true

class Emails::CreateEmailService < ApplicationService
  attr_reader :commit, :email_params, :user

  def initialize(commit:, email_params:, user:)
    super(commit: commit, email_params: email_params, user: user)
    @commit = commit
    @email_params = email_params
    @user = user
  end

  def call
    @email = if @commit == Email::SAVE_DRAFT
               @user.draft_status_emails.create(@email_params)
             else
               @user.sent_status_emails.create(@email_params)
             end
  end
end
