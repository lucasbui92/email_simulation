# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'users#index'

  devise_for :users

  get '/users/sign_out', to: 'devise/sessions#destroy'
  
  get 'sent', to: 'emails#sent'
  get 'draft', to: 'emails#draft'

  resources :emails, only: [:new, :create]
  resources :users do
    delete 'delete_emails', to: 'emails#destroy'
  end
end
