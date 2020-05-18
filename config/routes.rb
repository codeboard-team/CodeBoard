require 'sidekiq/web'

Rails.application.routes.draw do
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end


  devise_for :users, controllers: {omniauth_callbacks: 'omniauth'}
  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  resources :boards do
    collection do
      get :my
    end
    resources :cards do
      member do
        patch :solve 
      end
    end 
  end
end
