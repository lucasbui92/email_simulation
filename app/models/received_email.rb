class ReceivedEmail < ApplicationRecord
  enum recipient_type: { to: 0, bcc: 1, cc: 2 }
  enum status: { read: 1, unread: 0, deleted: 2 }

  belongs_to :user
  belongs_to :email, inverse_of: :received_emails
end