Rails.application.routes.draw do
  namespace :api do
    get 'wallets/index'
  end

  # For details on the DSL available within this file, see http://guides.rub  yonrails.org/routing.html

  namespace :api do
    resources :wallets, only: [:index]
  end
end
