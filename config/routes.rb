# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Covid Case Summary Endpoint
  get 'covid-case-summary', to: 'covid_cases#index', format: 'json'
end
