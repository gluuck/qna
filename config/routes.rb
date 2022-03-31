Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', confirmations: 'users/confirmations' }
  root to: 'questions#index'

  concern :vote do
    member do
      put :vote_up
      put :vote_down
      delete :destroy_vote
    end
  end

  concern :commented do
    member do
      get :new_comment
      post :create_comment
    end
  end
  resources :comments

  resources :questions, concerns: [:vote, :commented] do
    post :edit, on: :member
    resources :answers, concerns: [:vote, :commented], shallow: true  do
      post :edit, on: :member
      post :best_answer, on: :member
    end
  end

  resources :resource_files do
    delete :destroy, on: :member
  end

  resources :links do
    delete :destroy, on: :member
  end

  resources :rewards, only: :index

  mount ActionCable.server => '/cable'

  namespace :users do
    resources :emails, only: [:new, :create]
  end

  namespace :api, defaults:{format: :json} do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
      end
      resources :questions, only: %i[index show create update destroy]
      resources :answers ,only: %i[create update destroy]
    end
  end
end
