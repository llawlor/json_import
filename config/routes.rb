Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  root 'home#index'

  # require users to authenticate first
  authenticate :user do
    resources :records do
      collection do
        get 'import'
        post 'upload'
        delete 'delete'
        post 'export'
      end
    end
  end

end
