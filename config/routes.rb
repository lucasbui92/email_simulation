# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'users#index'

  devise_for :users

  get '/users/sign_out', to: 'devise/sessions#destroy'

  get 'inbox', to: 'emails#inbox'
  get 'sent', to: 'emails#sent'
  get 'draft', to: 'emails#draft'
  get 'delete', to: 'emails#delete'

  resources :emails, only: [:new, :create] do
    # Move all selected emails to `delete` folder
    put 'moved', to: 'emails#moved_to_trash', as: 'moved_to_trash'
  end

  resources :users do
    delete 'delete_emails', to: 'emails#destroy'
  end
end
