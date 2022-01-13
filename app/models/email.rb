# frozen_string_literal: true

class Email < ApplicationRecord
  SAVE_DRAFT = 'Save as draft'

  # Pointing towards the `through` tables
  has_many :received_emails, dependent: :delete_all
  has_many :sent_emails, dependent: :delete_all
  has_many :drafting_emails, dependent: :delete_all

  # Via `through` tables, get Email based on the status
  has_many :recipients, through: :received_emails, source: :user, inverse_of: :received_status_emails
  has_many :sender_users, through: :sent_emails, source: :user, inverse_of: :sent_status_emails
  has_many :drafter_users, through: :drafting_emails, source: :user, inverse_of: :draft_status_emails

  validates :subject, allow_blank: false, presence: true

  scope :starred_only, -> { includes(:received_emails).where(received_emails: { is_starred: true }) }
  scope :unstarred_only, -> { includes(:received_emails).where(received_emails: { is_starred: false }) }
  scope :inbox, -> { joins(:received_emails, :sender_users).select('emails.id, emails.subject, users.first_name, users.last_name, received_emails.status, received_emails.is_starred') }
  scope :sent, -> { joins(:sent_emails, :sender_users).select('emails.id, emails.subject, users.first_name, users.last_name') }
  scope :sorted_by, ->(column, value) { where("#{column} = ?", value) }
end
