# frozen_string_literal: true

class ReceivedEmail < ApplicationRecord
  EMAIL_READ = 1
  EMAIL_UNREAD = 0
  EMAIL_STARRED = 1
  EMAIL_UNSTARRED = 0

  enum recipient_type: { to: 0, bcc: 1, cc: 2 }
  enum status: { read: 1, unread: 0, deleted: 2 }

  belongs_to :user
  belongs_to :email, inverse_of: :received_emails

  scope :starred_status, ->(is_starred) { where('is_starred = ?', is_starred) }
  scope :is, ->(status) { where(status: status) }
end
