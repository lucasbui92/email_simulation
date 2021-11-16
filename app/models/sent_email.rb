# frozen_string_literal: true

class SentEmail < ApplicationRecord
  belongs_to :user
  belongs_to :email, inverse_of: :sent_emails
end
