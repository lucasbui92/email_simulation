# frozen_string_literal: true

class EmailsController < ApplicationController
  respond_to :html, :js

  skip_before_action :verify_authenticity_token, only: :sent

  before_action :set_presenter, except: [:show, :new]
  before_action :paginate_without_specification, except: [:new, :create]
  before_action :paginate_with_specification, only: [:create, :unfavorite, :mark_favorite, :mark_unfavorite, :mark_unread, :mark_read, :move_to_trash, :destroy]

  before_action :remove_email_id_after_retrieval, only: [:unfavorite, :mark_favorite, :mark_unfavorite, :mark_unread, :mark_read, :move_to_trash, :destroy]

  def show
    @email = Email.find(params[:id])
    Emails::ChangeEmailStatusService.call(email_id: @email.id, user: current_user)
  end

  def new
    @email = ComposeEmailForm.new(current_user)
  end

  def create
    @email = ComposeEmailForm.new(current_user, params[:commit], composing_email_params)
    if @email.save
      @emails = current_user.sent_status_emails.page(params[:page])
      params.delete(:compose_email_form)
      render @action = 'sent'
    else
      render :new
    end
  end

  def inbox
    @emails = current_user.received_status_emails.inbox.page(params[:page])
  end

  def sent
    @emails = current_user.sent_status_emails.sent.page(params[:page])
  end

  def draft
    @emails = current_user.draft_status_emails.page(params[:page])
  end

  def mark_favorite
    Emails::MarkFavoriteService.call(email_id: @email_id, user: current_user)
    @emails = current_user.received_status_emails.inbox.page(params[:page])

    render @action = 'inbox'
  end

  def mark_unfavorite
    Emails::MarkUnfavoriteService.call(email_id: @email_id, user: current_user)
    @emails = current_user.received_status_emails.inbox.page(params[:page])

    render @action = 'inbox'
  end

  def unfavorite
    Emails::MarkUnfavoriteService.call(email_id: @email_id, user: current_user)
    @emails = current_user.received_status_emails.starred_only.page(params[:page])

    render @action = 'starred'
  end

  def starred
    @emails = current_user.received_status_emails.starred_only.page(params[:page])
  end

  def mark_unread
    Emails::MarkUnreadService.call(email_id: @email_id, user: current_user)
    @emails = current_user.received_status_emails.inbox.page(params[:page])

    render @action = 'inbox'
  end

  def mark_read
    Emails::MarkReadService.call(email_id: @email_id, user: current_user)
    @emails = current_user.received_status_emails.inbox.page(params[:page])

    render @action = 'inbox'
  end

  def move_to_trash
    Emails::MoveToTrashService.call(email_id: @email_id, user: current_user, trash_category: params[:trash_category])

    @action = params[:trash_category]

    if params[:trash_category] == 'inbox'
      @emails = current_user.received_status_emails.inbox.sorted_by('received_emails.is_deleted', false)
    elsif params[:trash_category] == 'sent'
      @emails = current_user.sent_status_emails.sent.sorted_by('sent_emails.is_deleted', false)
    end

    @emails = @emails.page(params[:page])
    render @action
  end

  def trash
    @emails = current_user.received_status_emails.inbox.sorted_by('received_emails.is_deleted', true).page(params[:page])
  end

  def destroy
    # Handle deleting emails as recipient
    current_user.received_emails.where(email_id: params[:email_ids]).delete_all
    # @color_category = 'inbox-email'

    @emails = current_user.received_status_emails.inbox.where(is_deleted: true).page(params[:page])

    render @action = 'trash'
  end

  private

  def paginate_with_specification
    @condition = true
  end

  def paginate_without_specification
    @condition = false
  end

  def remove_email_id_after_retrieval
    @email_id = params[:email_id]
    params.delete(:email_id)
  end

  def set_presenter
    @presenter = presenter(object: Email.all, current_user: current_user)
  end

  def email_params
    params.require(:email).permit(:subject, :content)
  end

  def composing_email_params
    params.require(:compose_email_form).permit(:to, :subject, :content)
  end
end
