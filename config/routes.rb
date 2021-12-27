# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'users#index'

  devise_for :users

  get '/users/sign_out', to: 'devise/sessions#destroy'

  get 'inbox', to: 'emails#inbox'
  get 'sent', to: 'emails#sent'
  get 'draft', to: 'emails#draft'
  get 'starred', to: 'emails#starred'
  get 'delete', to: 'emails#delete'

  resources :emails, only: [:show, :new, :create] do
    # Move all selected emails to `delete` folder
    put 'moved', to: 'emails#moved_to_trash', as: 'moved_to_trash'
    put 'starred', to: 'emails#mark_favorite'
    put 'unstarred', to: 'emails#mark_unfavorite'
  end

  resources :users do
    delete 'delete_emails', to: 'emails#destroy'
  end
end
