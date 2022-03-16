Rails.application.routes.draw do
  devise_for :users
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
end
