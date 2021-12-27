# frozen_string_literal: true

class Users::IndexPresenter < BasePresenter
  presents :users

  def change_language(locale, translation_path)
    language_in?(locale, translation_path) do
      h.link_to translation_path, root_path(locale: User::CHINESE_CODE), class: 'link-color'
    end
  end

  def compose(translation_path)
    h.link_to translation_path, new_email_path(locale: I18n.locale), remote: true, class: 'link-color'
  end

  def inbox(translation_path)
    h.link_to translation_path, inbox_path(locale: I18n.locale), remote: true
  end

  def sent(translation_path)
    h.link_to translation_path, sent_path(locale: I18n.locale), remote: true
  end

  def draft(translation_path)
    h.link_to translation_path, draft_path(locale: I18n.locale), remote: true
  end

  def starred(translation_path)
    h.link_to translation_path, starred_path(locale: I18n.locale), remote: true
  end

  def delete(translation_path)
    h.link_to translation_path, delete_path(locale: I18n.locale), remote: true
  end

  def delete_selected(translation_path)
    h.link_to translation_path, user_delete_emails_path(current_user), method: :delete, class: 'link-color'
  end

  def sign_out(translation_path)
    h.link_to translation_path, destroy_user_session_path, method: :delete, class: 'link-color' if user_signed_in?
  end

  private

  def language_in?(language, translation_path)
    if language == User::ENGLISH_CODE
      yield
    else
      h.link_to translation_path, root_path(locale: User::ENGLISH_CODE), class: 'link-color'
    end
  end
end
