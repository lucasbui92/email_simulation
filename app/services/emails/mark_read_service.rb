# frozen_string_literal: true

class Emails::MarkReadService < ApplicationService
  attr_reader :email_id, :user

  def initialize(email_id:, user:)
    super(email_id: email_id, user: user)
    @email_id = email_id
    @user = user
  end

  def call
    @email = @user.received_emails.is('unread').find_by(email_id: @email_id)
    if @email.present?
      @email.status = 'read'
      @email.save
    end
  end
end
