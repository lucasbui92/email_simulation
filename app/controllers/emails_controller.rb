# frozen_string_literal: true

class EmailsController < ApplicationController
  respond_to :html, :js

  def new
    @email = ComposeEmailForm.new(current_user)
  end

  def create
    @email = ComposeEmailForm.new(current_user, params[:commit], composing_email_params)
    if @email.save
      @emails = current_user.sent_status_emails
    else
      render :new
    end
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

  def composing_email_params
    params.require(:compose_email_form).permit(:to, :subject, :content)
  end
end
