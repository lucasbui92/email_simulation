# frozen_string_literal: true

class EmailsController < ApplicationController
  respond_to :html, :js

  before_action :set_presenter, except: [:show, :new, :moved_to_trash, :destroy]

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
    else
      render :new
    end
  end

  def inbox
    @emails = current_user.received_status_emails.joins(:received_emails, :sender_users).select('emails.id, emails.subject, users.first_name, users.last_name').page(params[:page])
  end

  def sent
    @emails = current_user.sent_status_emails.page(params[:page])
  end

  def draft
    @emails = current_user.draft_status_emails.page(params[:page])
  end

  def mark_favorite
    Emails::MarkFavoriteService.call(email_id: params[:email_id], user: current_user)
    @emails = current_user.received_status_emails.includes(:received_emails)
  end

  def mark_unfavorite
    Emails::MarkUnfavoriteService.call(email_id: params[:email_id], user: current_user)
    @emails = current_user.received_status_emails.starred_only
  end

  def starred
    @emails = current_user.received_status_emails.starred_only.page(params[:page])
    # @emails = current_user.received_status_emails.joins(:received_emails).select('emails.*,  received_emails.is_starred')
  end

  def moved_to_trash
    Emails::MoveToTrashService.call(email_id: params[:email_id], user: current_user)
    @emails = current_user.sent_status_emails.where(is_deleted: false)
  end

  def delete
    @emails = current_user.sent_status_emails.where(is_deleted: true)
  end

  def destroy
    redirect_to root_path
  end

  private

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
