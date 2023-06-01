Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :sleep_records, only: %i[index create update]
    resources :friendships, only: %i[index create destroy]
    resources :rankings, only: :index
  end
end
