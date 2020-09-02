# frozen_string_literal: true

class Brewery < ApplicationRecord
  belongs_to :search

  validates :name,
            presence: true
  validates :state,
            presence: true
  validates :brewery_type,
            presence: true

  validates_with TypeValidator

  class << self
    def retrieve_breweries(state:, brewery_type:)
      # Only build query params of non-nil values
      query_params = {
        by_state: state,
        by_type: brewery_type
      }.compact

      breweries = ServiceClients::BreweryApiClient.http_get(query_params)

      # Added empty string on nil, since the Open Brewery DB API
      # doesn't specify its new brewery validations.
      # Going to take too long to dig around the repository.
      breweries.map do |brewery|
        new(
          name: brewery&.fetch('name', ''),
          state: brewery&.fetch('state', ''),
          brewery_type: brewery&.fetch('brewery_type', '')
        )
      end
    end
  end
end
