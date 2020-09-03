# frozen_string_literal: true

module ServiceClients
  class BreweryApiClient
    class << self
      def http_get(query_params)
        # Added in the client layer, since the API
        # only has one main resource endpoint
        endpoint_uri = '/breweries'

        response = get(BREWERY_API_URL, endpoint_uri, query_params)
        JSON.parse(response)
      end

      private

      def get(request_url, endpoint_uri, query_params)
        ServiceClients::BaseClient.http_get(request_url, endpoint_uri, query_params)
      end
    end
  end
end
