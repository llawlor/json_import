Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  # require users to authenticate first
  authenticate :user do
    resources :records do
      collection do
        get 'import'
        post 'upload'
      end
    end
  end

end
