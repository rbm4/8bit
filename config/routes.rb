Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'static_pages#index'
  post '/', to: "static_pages#index"
  match 'currency/:currency', to: 'static_pages#index', via: [:get, :post]
  post 'buy_ticket', to: "static_pages#buy_ticket"
  post '/wallet_history', to: "static_pages#history"
  post '/email_notify', to: "static_pages#save_email"
  post "notify/cpay", to: "notify#confirm_transaction"
end
