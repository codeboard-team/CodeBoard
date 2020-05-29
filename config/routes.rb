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
    resources :cards, except: [:index] do
      member do
        patch :solve 
        get :solve
      end
    end 
  end

  resources :cards
  
end
