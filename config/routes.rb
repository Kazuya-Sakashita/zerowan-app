Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    post 'users/sign_up/confirm', to: 'devise/registrations#confirm'
    get 'users/sign_up/complete', to: 'devise/registrations#complete'
  end
end
