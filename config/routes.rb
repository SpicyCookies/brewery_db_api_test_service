# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Search Endpoint
  resources :searches, only: [:index]

  # Clear searches
  scope '/searches' do
    delete 'clear', to: 'searches#delete_all_searches'
  end
end
