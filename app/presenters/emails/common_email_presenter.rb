# frozen_string_literal: true

class Emails::CommonEmailPresenter < BasePresenter
  presents :emails

  def highlight_email(inbox, email)
    highlight = inbox && email.received_emails.first.unread? ? 'highlight-email-link' : ''
    h.link_to email.subject, email, remote: true, class: highlight.to_s
  end

  def move_email_to_trash(deletable, email)
    h.link_to ('<i class="fas fa-trash"></i>').html_safe, email_moved_to_trash_path(email), method: :put, remote: true, class: 'trash-link' unless deletable
  end

  def mark_email_as_favorite(inbox, email)
    h.link_to ('<i class="fas fa-star"></i>').html_safe, email_starred_path(email), method: :put, remote: true, class: 'star-link' if inbox
  end

  def unmark_favorite_email(starred, email)
    h.link_to ('<i class="far fa-star"></i>').html_safe, email_unstarred_path(email), method: :put, remote: true, class: 'star-link' if starred
  end
end
