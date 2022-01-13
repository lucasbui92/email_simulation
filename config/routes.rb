# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'users#index'

  devise_for :users

  get '/users/sign_out', to: 'devise/sessions#destroy'

  get 'inbox', to: 'emails#inbox'
  get 'sent', to: 'emails#sent'
  get 'draft', to: 'emails#draft'
  get 'starred', to: 'emails#starred'
  get 'trash', to: 'emails#trash'

  resources :emails, only: [:show, :new, :create] do
    # Move all selected emails to `delete` folder
    put 'delete', to: 'emails#move_to_trash'

    # Unstar email items within the Starred category
    put 'unfavorite', to: 'emails#unfavorite'

    put 'starred', to: 'emails#mark_favorite'
    put 'unstarred', to: 'emails#mark_unfavorite'
    put 'read', to: 'emails#mark_read'
    put 'unread', to: 'emails#mark_unread'
  end

  put 'delete_selected_emails', to: 'emails#destroy'
end
