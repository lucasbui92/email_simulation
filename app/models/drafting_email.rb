# frozen_string_literal: true

class DraftingEmail < ApplicationRecord
  belongs_to :user
  belongs_to :email, inverse_of: :drafting_emails
end
