# frozen_string_literal: true

class Email < ApplicationRecord
  SAVE_DRAFT = 'Save as draft'

  has_many :sent_emails, dependent: :destroy
  has_many :drafting_emails, dependent: :destroy

  has_many :sender_users, through: :sent_emails, source: :user, inverse_of: :sent_status_emails
  has_many :drafter_users, through: :drafting_emails, source: :user, inverse_of: :draft_status_emails

  validates :subject, allow_blank: false, presence: true

  # accepts_nested_attributes_for :sent_emails
end
