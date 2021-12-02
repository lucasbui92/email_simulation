# frozen_string_literal: true

class EmailsController < ApplicationController
  respond_to :html, :js

  def new
    @email = Email.new
  end

  def create
    @email = Emails::CreateEmailService.call(commit: params[:commit], email_params: email_params, user: current_user)
    render :new if @email.errors.any?
    @emails = current_user.sent_status_emails
  end

  def sent
    @emails = current_user.sent_status_emails.has_sent_emails
  end

  def draft
    @emails = current_user.draft_status_emails
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

  def email_params
    params.require(:email).permit(:subject, :content)
  end
end
