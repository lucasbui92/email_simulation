# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'users#index'

  devise_for :users

  # resources :users, only: [:destroy]
  get '/users/sign_out', to: 'devise/sessions#destroy'
end
