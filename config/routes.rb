Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  resources :questions do
    post :edit, on: :member
    resources :answers, shallow: true  do
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
end
