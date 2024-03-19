Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

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
      get "reload_images", action: :reload_images
    end
    resources :comments, only: %i[index new create show edit update destroy], shallow: true do
      collection do
        get "cancel_new_comment", action: :cancel_new_comment
        get "not_loggedin_comment", action: :not_loggedin_comment
        get "search", action: :search
        get "cancel_search", action: :cancel_search
      end
      member do
        get "cancel_edit", action: :cancel_edit
        delete "delete_comment_image", action: :delete_comment_image
      end
      resources :comment_replies, only: %i[index new create show edit update destroy], shallow: true do
        collection do
          get "cancel_new", action: :cancel_new
          get "search", action: :search
          get "cancel_search", action: :cancel_search
        end
        member do
          get "cancel_edit", action: :cancel_edit
          delete "delete_comment_reply_image", action: :delete_comment_reply_image
          get "reply_to_parent", action: :reply_to_parent
        end
      end
    end
  end
  resources :bookmarks, only: %i[create destroy]
  resources :favorites, only: %i[create destroy]
  resource :my_page, only: %i[show edit update] do
    collection do
      get "bookmarks", action: :bookmarks
      get "my_posts", action: :my_posts
      delete "delete_avatar", action: :delete_avatar
      post "save_results", action: :save_results
    end
  end
  resources :password_resets, only: %i[new create edit update]
  resources :diagnosis_contents, only: %i[show]
  resources :diagnosis_questions, only: %i[index] do
    collection do
      post "calculate", action: :calculate
      get "result", action: :result
    end
  end
  resources :diagnosis_results, only: %i[show edit update destroy] do
    member do
      get "cancel_edit", action: :cancel_edit
      get "compatible", action: :compatible
      get "not_compatible", action: :not_compatible
      patch "change_compatible", action: :change_compatible
      patch "change_not_compatible", action: :change_not_compatible
    end
  end
  resources :notifications, only: %i[update] do
    collection do
      patch "mark_all_as_read", action: :mark_all_as_read
    end
  end
end
