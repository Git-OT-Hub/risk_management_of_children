Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "top_pages#top"

  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  post "guest_login", to: "user_sessions#guest_login"

  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider

  resources :top_pages
  resources :users, only: %i[new create]
  resources :posts, only: %i[index new create show edit update destroy] do
    member do
      delete "delete_image/:image_id", action: :delete_image, as: :delete_image
    end
    resources :comments, only: %i[index new create show edit update destroy], shallow: true do
      collection do
        get "cancel_new_comment", action: :cancel_new_comment
        get "not_loggedin_comment", action: :not_loggedin_comment
      end
      member do
        get "cancel_edit", action: :cancel_edit
        delete "delete_comment_image", action: :delete_comment_image
      end
    end
  end
end
