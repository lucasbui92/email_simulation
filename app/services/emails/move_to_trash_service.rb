# frozen_string_literal: true

class Emails::MoveToTrashService < ApplicationService
  attr_reader :email_id, :user

  def initialize(email_id:, user:, trash_category:)
    super(email_id: email_id, user: user, trash_category: trash_category)
    @email_id = email_id
    @user = user
    @trash_category = trash_category
  end

  def call
    # Need to add `is_deleted` to `received_emails`
    if @trash_category == 'inbox'
      # @email = @user.received_status_emails.find(@email_id)
      @email_state = @user.received_emails.find_by(email_id: @email_id)
    elsif @trash_category == 'sent'
      @email_state = @user.sent_status_emails.find(email_id: @email_id)
    end
    @email_state.is_deleted = true
    @email_state.save
  end
end
