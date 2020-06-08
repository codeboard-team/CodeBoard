Rails.application.routes.draw do

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


  resources :profiles, only: [:show]
  resources :cards, only: [:index] ,to: 'cards#list'

  resources :cards, only: [:index], to: 'cards#list'

  resources :records, only: [:show]
  
end
