# frozen_string_literal: true

class Emails::MarkUnreadService < ApplicationService
  attr_reader :email_id, :user

  def initialize(email_id:, user:)
    super(email_id: email_id, user: user)
    @email_id = email_id
    @user = user
  end

  def call
    @email = @user.received_emails.is('read').find_by(email_id: @email_id)
    if @email.present?
      @email.status = 'unread'
      @email.save
    end
  end
end
