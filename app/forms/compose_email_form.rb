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
        sent_email.save!
      end
    end
  end

  private

  def drafting_email
    @email ||= @user.draft_status_emails.new(subject: subject, content: content)
  end

  def sent_email
    @email ||= @user.sent_status_emails.new(subject: subject, content: content)
  end

  def email_input
    if @commit == Email::SAVE_DRAFT
      promote_errors(drafting_email) if drafting_email.invalid?
    else
      promote_errors(sent_email) if sent_email.invalid?
    end
  end

  def promote_errors(object)
    object.errors.each do |error|
      errors.add(error.attribute, error.message)
    end
  end
end
