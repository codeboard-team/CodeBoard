require 'sidekiq/web'

Rails.application.routes.draw do
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end


  devise_for :users, controllers: {omniauth_callbacks: 'omniauth'}
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

  resources :cards
  resources :profiles, only: [:show]
  resources :cards, only: [:index] ,to: 'cards#list'
  
end
