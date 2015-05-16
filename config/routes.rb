Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  # require users to authenticate first
  authenticate :user do
    resources :records do
      collection do
        get 'import'
        post 'upload'
        delete 'delete'
      end
    end
  end

end
