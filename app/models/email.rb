# frozen_string_literal: true

class Email < ApplicationRecord
  SAVE_DRAFT = 'Save as draft'

  # Pointing towards the `through` tables
  has_many :received_emails, dependent: :destroy
  has_many :sent_emails, dependent: :destroy
  has_many :drafting_emails, dependent: :destroy

  # Via `through` tables, get Email based on the status
  has_many :recipients, through: :received_emails, source: :user, inverse_of: :received_status_emails
  has_many :sender_users, through: :sent_emails, source: :user, inverse_of: :sent_status_emails
  has_many :drafter_users, through: :drafting_emails, source: :user, inverse_of: :draft_status_emails

  validates :subject, allow_blank: false, presence: true

  scope :starred_only, -> { includes(:received_emails).where(received_emails: { is_starred: true }) }
  scope :unstarred_only, -> { includes(:received_emails).where(received_emails: { is_starred: false }) }

  # accepts_nested_attributes_for :sent_emails
end
