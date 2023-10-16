Rails.application.routes.draw do
  namespace :admins do
    get 'home/index'
  end

  root 'home#index'

  resource :users, only: [:show, :edit]
  resource :profiles, only: [:update]
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get '/users/sign_out' => 'users/sessions#destroy'
    post 'users/sign_up/confirm', to: 'users/registrations#confirm'
    get 'users/sign_up/complete', to: 'users/registrations#complete'
  end

  devise_for :admins, controllers: {
    registrations: 'admins/registrations',
    sessions: 'admins/sessions',
    confirmations: 'admins/confirmations'
  }

  namespace :admins do
    root 'home#index'
    delete 'sign_out', to: 'sessions#destroy', as: :destroy_admin_session
  end

  resources :pets, except: [:index] do
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

  resources :members, only: [:show] do
    resources :pets, only: %i[index], module: :members
  end
end
