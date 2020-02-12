Rails.application.routes.draw do
  resources :suggestions
  get '/repos/:id/analysis', to: "repos#analysis"
  resources :repos
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
