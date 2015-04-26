Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  resources :records do
    collection do
      get 'import'
      post 'upload'
    end
  end

end
