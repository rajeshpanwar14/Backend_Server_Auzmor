Rails.application.routes.draw do
  resources :accounts
  post '/inbound/sms', to: 'inbound_sms#create'
  post '/outbound/sms', to: 'outbound_sms#create'
end
