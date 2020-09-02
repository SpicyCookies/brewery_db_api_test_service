# frozen_string_literal: true

module ServiceClients
  class BaseClient
    class << self
      def http_get(request_url, endpoint_uri, query_params = {}, options = {})
        response = configure(request_url, options).get(endpoint_uri, query_params)
        handle_response(response, request_url + endpoint_uri)
      end

      private

      def configure(request_url, options = {})
        Faraday.new(request_url, options) do |faraday|
          # Allow array parameters to be passed
          faraday.options.params_encoder = Faraday::FlatParamsEncoder
          faraday.options.timeout = services_config['read_timeout_default'].to_i
          faraday.options.open_timeout = services_config['open_timeout_default'].to_i
          faraday.headers = options.fetch(:headers, {})
          faraday.request :retry, max: services_config[:retries_default], interval: 0.05
          faraday.adapter Faraday.default_adapter
        end
      end

      def services_config
        ::Rails.application.config_for(:services).with_indifferent_access
      end

      def handle_response(response, path)
        return response.body if [200].include? response.status

        error = {
          400 => HotelEngineTestService::Errors::BadRequestError.new(response.status, path, response.body),
          401 => HotelEngineTestService::Errors::UnauthorizedRequestError.new(response.status, path, response.body),
          403 => HotelEngineTestService::Errors::ForbiddenRequestError.new(response.status, path, response.body),
          404 => HotelEngineTestService::Errors::ResourceNotFoundError.new(response.status, path, 'Resource Not Found'),
          422 => HotelEngineTestService::Errors::UnprocessableEntityError.new(response.status, path, response.body),
        }.fetch(
          response.status,
          HotelEngineTestService::Errors::BadHttpResponseError.new(response.status, path, response.body)
        )

        raise error
      end
    end
  end
end
