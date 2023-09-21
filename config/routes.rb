Rails.application.routes.draw do
  root 'home#index'

  resource :users, only: [:show, :edit]
  resource :profiles, only: [:update]
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    post 'users/sign_up/confirm', to: 'users/registrations#confirm'
    get 'users/sign_up/complete', to: 'users/registrations#complete'
  end

  resources :pets do
    resource :favorites, only: [:create, :destroy]
    resource :rooms, only: [:create, :show]
  end
  # post 'pets/confirm', to: 'pets#confirm'

  resources :home, only: [:index] do
    collection do
      match 'search' => 'home#search', via: [:get, :post], as: :search
    end
  end

  resources :rooms do
    resources :messages, only: [:index,:new, :create]
  end
  resources :messages, only: [:edit, :update, :destroy]
end
