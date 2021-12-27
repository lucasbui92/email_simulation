# frozen_string_literal: true

class ComposeEmailForm
  include ActiveModel::Model

  attr_accessor :to, :subject, :content, :commit

  validate :email_input

  def initialize(user, commit = nil, params = {})
    @user = user
    @commit = commit
    super(params)
  end

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      if @commit == Email::SAVE_DRAFT
        drafting_email.save!
      else
        process_sending_email
      end
    end
  end

  private

  def process_sending_email
    sent_email.save!

    recipient = User.find_by(email: to)
    return if recipient.blank?

    recipient_email(recipient, sent_email).save!
    MyMailer.sending_email(@user, to, subject, content).deliver_later
  end

  def recipient_email(recipient, email)
    recipient.received_emails.new(email_id: email.id)
  end

  def drafting_email
    @drafting_email ||= @user.draft_status_emails.new(subject: subject, content: content)
  end

  def sent_email
    @sent_email ||= @user.sent_status_emails.new(subject: subject, content: content)
  end

  def email_input
    if @commit == Email::SAVE_DRAFT
      promote_errors(drafting_email) if drafting_email.invalid?
    elsif sent_email.invalid?
      promote_errors(sent_email)
    end
  end

  def promote_errors(object)
    object.errors.each do |error|
      errors.add(error.attribute, error.message)
    end
  end
end
