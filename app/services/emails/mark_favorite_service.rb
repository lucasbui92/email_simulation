# frozen_string_literal: true

class Emails::MarkFavoriteService < ApplicationService
  attr_reader :email_id, :user

  def initialize(email_id:, user:)
    super(email_id: email_id, user: user)
    @email_id = email_id
    @user = user
  end

  def call
    @email = @user.received_emails.starred_status(false).find_by(email_id: @email_id)
    if @email.present?
      @email.is_starred = true
      @email.save
    end
  end
end
