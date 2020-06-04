require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # sessions: 'users/sessions',
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks'}
  root to: 'home#index'
  
  resources :boards do
    collection do
      get :my
    end
    resources :cards do
      member do
        patch :solve 
        get :solve, to: 'cards#show'
      end
    end 
  end

  resources :cards, only: [:index] ,to: 'cards#list'
  resources :cards
  resources :profiles, only: [:show]
  resources :cards, only: [:index] ,to: 'cards#list'
  
end
