# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  ENGLISH_CODE = 'en'
  CHINESE_CODE = 'cn'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sent_emails, dependent: :destroy
  has_many :drafting_emails, dependent: :destroy

  has_many :sent_status_emails, through: :sent_emails, source: :email, inverse_of: :sender_users
  has_many :draft_status_emails, through: :drafting_emails, source: :email, inverse_of: :drafter_users

  validates :date_of_birth, presence: true
end
