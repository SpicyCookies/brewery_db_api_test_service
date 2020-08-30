# frozen_string_literal: true

module ServiceClients
  class CovidApiClient
    class << self
      def retrieve_case_summary
        endpoint_uri = '/summary'

        get(COVID_API_URL, endpoint_uri)
      end

      private

      def get(request_url, endpoint_uri)
        ServiceClients::BaseClient.http_get(request_url, endpoint_uri)
      end
    end
  end
end
