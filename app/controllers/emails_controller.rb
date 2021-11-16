# frozen_string_literal: true

class EmailsController < ApplicationController
  def new
    @email = Email.new
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @email = Emails::CreateEmailService.call(commit: params[:commit], email_params: email_params, user: current_user)
        redirect_to root_path
      end
    rescue StandardError => e
      # render :new
      # Rails.logger.error e
      flash[:error] = e
      # redirect_to root_path
    end
  end

  def sent
    @emails = current_user.sent_status_emails
  end

  def draft
    @emails = current_user.draft_status_emails
  end

  def destroy
    redirect_to root_path
  end

  private

  def email_params
    params.require(:email).permit(:subject, :content)
  end
end
