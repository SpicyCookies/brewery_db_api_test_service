# frozen_string_literal: true

require 'rails_helper'

describe ServiceClients::BaseClient do
  let(:api_url) { 'https://test' }
  let(:header) { {} }

  shared_examples 'an HTTP call' do |http_type, http_method|
    describe ".http_#{http_type}" do
      let(:options) { { headers: header } }
      let(:endpoint_uri) { '/test' }

      let(:response_status) { 200 }
      let(:response) { double(status: response_status, body: 'body') }

      before do
        expect_any_instance_of(Faraday::Connection).to receive(http_type).and_return(response)
      end

      context 'when response is 200' do
        it 'returns the response body' do
          expect(described_class.public_send(http_method, api_url, endpoint_uri, options)).to eq(response.body)
        end
      end

      context 'when response is 400' do
        let(:response_status) { 400 }
        it 'raises BadHttpResponseError' do
          expect { described_class.public_send(http_method, api_url, endpoint_uri, options)}
            .to raise_error(HotelEngineTestService::Errors::BadRequestError)
        end
      end

      context 'when response is 401' do
        let(:response_status) { 401 }
        it 'raises UnauthorizedRequestError' do
          expect { described_class.public_send(http_method, api_url, endpoint_uri, options)}
            .to raise_error(HotelEngineTestService::Errors::UnauthorizedRequestError)
        end
      end

      context 'when response is 403' do
        let(:response_status) { 403 }
        it 'raises ForbiddenRequestError' do
          expect { described_class.public_send(http_method, api_url, endpoint_uri, options)}
            .to raise_error(HotelEngineTestService::Errors::ForbiddenRequestError)
        end
      end

      context 'when response is 404' do
        let(:response_status) { 404 }
        it 'raises ResourceNotFoundError' do
          expect { described_class.public_send(http_method, api_url, endpoint_uri, options)}
            .to raise_error(HotelEngineTestService::Errors::ResourceNotFoundError)
        end
      end

      context 'when response is 422' do
        let(:response_status) { 422 }
        it 'raises ResourceConflictError' do
          expect { described_class.public_send(http_method, api_url, endpoint_uri, options)}
            .to raise_error(HotelEngineTestService::Errors::UnprocessableEntityError)
        end
      end

      context 'when response is 500' do
        let(:response_status) { 500 }
        it 'raises BadHttpResponseError' do
          expect { described_class.public_send(http_method, api_url, endpoint_uri, options)}
            .to raise_error(HotelEngineTestService::Errors::BadHttpResponseError)
        end
      end
    end
  end

  include_examples 'an HTTP call', :get, :http_get
end
