# frozen_string_literal: true

class Emails::CommonEmailPresenter < BasePresenter
  presents :emails

  def highlight_email(inbox, email)
    highlight = inbox && email.received_emails.first.unread? ? 'highlight-email-link' : ''
    h.link_to email.subject, email, remote: true, class: highlight.to_s
  end

  def move_email_to_trash(trash_category=nil, email)
    h.link_to ('<i class="fas fa-trash"></i>').html_safe, email_delete_path(email, trash_category: trash_category), method: :put, remote: true, class: 'trash-link' if trash_category
  end

  def unmark_favorite_email(starred, email)
    h.link_to ('<i class="fas fa-star"></i>').html_safe, email_unfavorite_path(email), method: :put, remote: true, class: 'star-link' if starred
  end

  def mark_email_status(inbox, email, is_checking_starred=false)
    return unless inbox

    symbol, path, class_name = get_symbol_and_path(email, is_checking_starred)
    h.link_to (symbol).html_safe, path, method: :put, remote: true, class: class_name
  end

  private

  def get_symbol_and_path(email, is_checking_starred)
    symbol = '<i class="far fa-star"></i>'
    path = email_starred_path(email)
    class_name = 'star-link'

    if is_checking_starred == true && email.is_starred == ReceivedEmail::EMAIL_STARRED
      symbol = '<i class="fas fa-star"></i>'
      path = email_unstarred_path(email)
    end

    if is_checking_starred == false
      symbol = '<i class="fas fa-envelope"></i>'
      path = email_unread_path(email)
      class_name = 'read-unread-link'

      if email.status == ReceivedEmail::EMAIL_UNREAD
        symbol = '<i class="fas fa-envelope-open"></i>'
        path = email_read_path(email)
      end
    end

    return symbol, path, class_name
  end
end
