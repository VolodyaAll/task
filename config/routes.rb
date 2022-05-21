# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tournaments#index'

  resources :tournaments, except: %i[edit update] do
    post :create_playoff, on: :member
    resources :divisions, only: %i[edit update]
  end

  resources :teams, only: %i[index new create destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
