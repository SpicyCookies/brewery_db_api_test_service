# frozen_string_literal: true

# frozen_string_literal: true

require 'rails_helper'

# TODO: Refactor these specs. Too much redundancy, can utilize shared_examples.
describe '/searches', type: :request do
  # Faraday connection object
  let(:brewery_api_url) { BREWERY_API_URL }
  let(:options) { {} }
  let(:faraday_connection) { double(Faraday::Connection) }

  # Faraday connection object get method
  let(:endpoint_uri) { '/breweries' }
  let(:faraday_query_params) { {} }
  # Set external API mock response
  let(:faraday_response) do
    double(
      Faraday::Response,
      status: 200,
      body: breweries.to_json
    )
  end

  before do
    allow(Faraday)
      .to receive(:new)
      .with(brewery_api_url, options)
      .and_return(faraday_connection)
    allow(faraday_connection)
      .to receive(:get)
      .with(endpoint_uri, faraday_query_params)
      .and_return(faraday_response)
  end

  describe '#index' do
    # Build external API mock response
    let(:brewery_1_state) { Faker::Address.unique.state }
    let(:brewery_1_name) { Faker::Beer.unique.brand }
    let(:brewery_1_type) { 'brewpub' }
    let(:brewery_1) do
      {
        name: brewery_1_name,
        state: brewery_1_state,
        brewery_type: brewery_1_type
      }
    end
    let(:brewery_2_state) { Faker::Address.unique.state }
    let(:brewery_2_name) { Faker::Beer.unique.brand }
    let(:brewery_2_type) { 'micro' }
    let(:brewery_2) do
      {
        name: brewery_2_name,
        state: brewery_2_state,
        brewery_type: brewery_2_type
      }
    end
    let(:breweries) { [brewery_1, brewery_2] }

    context 'with no params passed' do
      let(:request_query_params) { {} }
      let(:expected_response) do
        [
          {
            'name' => brewery_1_name,
            'brewery_type' => brewery_1_type,
            'state' => brewery_1_state
          },
          {
            'name' => brewery_2_name,
            'brewery_type' => brewery_2_type,
            'state' => brewery_2_state
          }
        ]
      end

      subject do
        get '/searches', params: request_query_params
      end

      context 'with external API returning breweries' do
        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully retrieves breweries' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array(expected_response)
        end
      end

      context 'with external API not returning breweries' do
        let(:breweries) { [] }

        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully retrieves an empty array' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array([])
        end
      end

      context 'with pre-existing search' do
        let(:search_id) { 1 }
        let(:duplicate_search) do
          FactoryBot.create(
            :search,
            id: search_id,
            state: nil,
            brewery_type: nil
          )
        end

        let(:duplicate_search_brewery_name) { "duplicate #{brewery_1_name}" }
        let(:duplicate_search_brewery_type) { brewery_1_type.to_s }
        let(:duplicate_search_brewery_state) { brewery_1_state.to_s }
        let(:duplicate_search_brewery) do
          FactoryBot.create(
            :brewery,
            search_id: search_id,
            name: duplicate_search_brewery_name,
            brewery_type: duplicate_search_brewery_type,
            state: duplicate_search_brewery_state
          )
        end

        let(:expected_response) do
          [
            {
              'name' => duplicate_search_brewery_name,
              'brewery_type' => duplicate_search_brewery_type,
              'state' => duplicate_search_brewery_state
            }
          ]
        end

        before do
          duplicate_search
          duplicate_search_brewery
        end

        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully renders duplicate brewery response' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array(expected_response)
        end
      end
    end

    context 'with state query param passed' do
      let(:brewery_state) { Faker::Address.unique.state }

      # Modify Faraday::Connection stub
      let(:faraday_query_params) { { by_state: brewery_state } }

      # Modify external API mock response
      let(:brewery_1_state) { brewery_state }
      let(:brewery_2_state) { brewery_state }

      let(:request_query_params) { { state: brewery_state } }

      let(:expected_response) do
        [
          {
            'name' => brewery_1_name,
            'brewery_type' => brewery_1_type,
            'state' => brewery_1_state
          },
          {
            'name' => brewery_2_name,
            'brewery_type' => brewery_2_type,
            'state' => brewery_2_state
          }
        ]
      end

      subject do
        get '/searches', params: request_query_params
      end

      context 'with external API returning breweries' do
        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully retrieves breweries' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array(expected_response)
        end
      end

      context 'with external API not returning breweries' do
        let(:breweries) { [] }

        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully retrieves an empty array' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array([])
        end
      end

      context 'with pre-existing search' do
        let(:search_id) { 1 }
        let(:duplicate_search) do
          FactoryBot.create(
            :search,
            id: search_id,
            state: brewery_state,
            brewery_type: nil
          )
        end

        let(:duplicate_search_brewery_name) { "duplicate #{brewery_1_name}" }
        let(:duplicate_search_brewery_type) { brewery_1_type.to_s }
        let(:duplicate_search_brewery_state) { brewery_state.to_s }
        let(:duplicate_search_brewery) do
          FactoryBot.create(
            :brewery,
            search_id: search_id,
            name: duplicate_search_brewery_name,
            brewery_type: duplicate_search_brewery_type,
            state: duplicate_search_brewery_state
          )
        end

        let(:expected_response) do
          [
            {
              'name' => duplicate_search_brewery_name,
              'brewery_type' => duplicate_search_brewery_type,
              'state' => duplicate_search_brewery_state
            }
          ]
        end

        before do
          duplicate_search
          duplicate_search_brewery
        end

        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully renders duplicate brewery response' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array(expected_response)
        end
      end
    end

    context 'with brewery_type query param passed' do
      let(:brewery_type) { 'bar' }

      # Modify Faraday::Connection stub
      let(:faraday_query_params) { { by_type: brewery_type } }

      # Modify external API mock response
      let(:brewery_1_type) { brewery_type }
      let(:brewery_2_type) { brewery_type }

      let(:request_query_params) { { brewery_type: brewery_type } }

      let(:expected_response) do
        [
          {
            'name' => brewery_1_name,
            'brewery_type' => brewery_1_type,
            'state' => brewery_1_state
          },
          {
            'name' => brewery_2_name,
            'brewery_type' => brewery_2_type,
            'state' => brewery_2_state
          }
        ]
      end

      subject do
        get '/searches', params: request_query_params
      end

      context 'with external API returning breweries' do
        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully retrieves breweries' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array(expected_response)
        end
      end

      context 'with external API not returning breweries' do
        let(:breweries) { [] }

        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully retrieves an empty array' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array([])
        end
      end

      context 'with pre-existing search' do
        let(:search_id) { 1 }
        let(:duplicate_search) do
          FactoryBot.create(
            :search,
            id: search_id,
            state: nil,
            brewery_type: brewery_type
          )
        end

        let(:duplicate_search_brewery_name) { "duplicate #{brewery_1_name}" }
        let(:duplicate_search_brewery_type) { brewery_type.to_s }
        let(:duplicate_search_brewery_state) { brewery_1_state.to_s }
        let(:duplicate_search_brewery) do
          FactoryBot.create(
            :brewery,
            search_id: search_id,
            name: duplicate_search_brewery_name,
            brewery_type: duplicate_search_brewery_type,
            state: duplicate_search_brewery_state
          )
        end

        let(:expected_response) do
          [
            {
              'name' => duplicate_search_brewery_name,
              'brewery_type' => duplicate_search_brewery_type,
              'state' => duplicate_search_brewery_state
            }
          ]
        end

        before do
          duplicate_search
          duplicate_search_brewery
        end

        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully renders duplicate brewery response' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array(expected_response)
        end
      end
    end

    context 'with state and brewery_type query params passed' do
      let(:brewery_state) { Faker::Address.unique.state }
      let(:brewery_type) { 'bar' }

      # Modify Faraday::Connection stub
      let(:faraday_query_params) { { by_state: brewery_state, by_type: brewery_type } }

      # Modify external API mock response
      let(:brewery_1_state) { brewery_state }
      let(:brewery_2_state) { brewery_state }
      let(:brewery_1_type) { brewery_type }
      let(:brewery_2_type) { brewery_type }

      let(:request_query_params) { { state: brewery_state, brewery_type: brewery_type } }

      let(:expected_response) do
        [
          {
            'name' => brewery_1_name,
            'brewery_type' => brewery_1_type,
            'state' => brewery_1_state
          },
          {
            'name' => brewery_2_name,
            'brewery_type' => brewery_2_type,
            'state' => brewery_2_state
          }
        ]
      end

      subject do
        get '/searches', params: request_query_params
      end

      context 'with external API returning breweries' do
        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully retrieves breweries' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array(expected_response)
        end
      end

      context 'with external API not returning breweries' do
        let(:breweries) { [] }

        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully retrieves an empty array' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array([])
        end
      end

      context 'with pre-existing search' do
        let(:search_id) { 1 }
        let(:duplicate_search) do
          FactoryBot.create(
            :search,
            id: search_id,
            state: brewery_state,
            brewery_type: brewery_type
          )
        end

        let(:duplicate_search_brewery_name) { "duplicate #{brewery_1_name}" }
        let(:duplicate_search_brewery_type) { brewery_type.to_s }
        let(:duplicate_search_brewery_state) { brewery_state.to_s }
        let(:duplicate_search_brewery) do
          FactoryBot.create(
            :brewery,
            search_id: search_id,
            name: duplicate_search_brewery_name,
            brewery_type: duplicate_search_brewery_type,
            state: duplicate_search_brewery_state
          )
        end

        let(:expected_response) do
          [
            {
              'name' => duplicate_search_brewery_name,
              'brewery_type' => duplicate_search_brewery_type,
              'state' => duplicate_search_brewery_state
            }
          ]
        end

        before do
          duplicate_search
          duplicate_search_brewery
        end

        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully renders duplicate brewery response' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array(expected_response)
        end
      end
    end

    context 'with sort params passed' do
      subject do
        get '/searches', params: request_query_params
      end

      context 'with sort_by name' do
        let(:request_query_params) { { sort_by: 'name' } }

        # Modify breweries to be unsorted
        let(:brewery_1_name) { 'a' }
        let(:brewery_2_name) { 'z' }

        let(:expected_brewery_1) do
          {
            'name' => 'a',
            'brewery_type' => brewery_1_type,
            'state' => brewery_1_state
          }
        end
        let(:expected_brewery_2) do
          {
            'name' => 'z',
            'brewery_type' => brewery_2_type,
            'state' => brewery_2_state
          }
        end

        it 'renders a 200 status' do
          subject
          expect(response).to have_http_status(200)
        end

        it 'successfully retrieves asc default sorted breweries' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to eq([expected_brewery_1, expected_brewery_2])
        end

        context 'with sort_type asc' do
          let(:request_query_params) { { sort_by: 'name', sort_type: 'asc' } }

          # Modify breweries to be unsorted
          let(:brewery_1_name) { 'z' }
          let(:brewery_2_name) { 'a' }

          let(:expected_brewery_1) do
            {
              'name' => 'a',
              'brewery_type' => brewery_2_type,
              'state' => brewery_2_state
            }
          end
          let(:expected_brewery_2) do
            {
              'name' => 'z',
              'brewery_type' => brewery_1_type,
              'state' => brewery_1_state
            }
          end

          it 'renders a 200 status' do
            subject
            expect(response).to have_http_status(200)
          end

          it 'successfully retrieves asc sorted breweries' do
            subject
            response_body = JSON.parse(response.body)
            expect(response_body).to eq([expected_brewery_1, expected_brewery_2])
          end
        end

        context 'with sort_type desc' do
          let(:request_query_params) { { sort_by: 'name', sort_type: 'desc' } }

          # Modify breweries to be unsorted
          let(:brewery_1_name) { 'a' }
          let(:brewery_2_name) { 'z' }

          it 'renders a 200 status' do
            subject
            expect(response).to have_http_status(200)
          end

          it 'successfully retrieves desc sorted breweries' do
            subject
            response_body = JSON.parse(response.body)
            expect(response_body).to eq([expected_brewery_2, expected_brewery_1])
          end
        end
      end
    end

    context 'with invalid brewery_type query param passed' do
      # TODO: Fix retry limit. "Random" values added instead.
      let(:brewery_1_name) { 'Free State Brewing Company' }
      let(:brewery_2_name) { 'Boulevard Brewing Company' }

      let(:request_query_params) { { brewery_type: 'invalid type' } }

      let(:expected_response) do
        {
          'error' => {
            'body' => 'brewery_type is invalid!',
            'path' => '',
            'status' => 400
          }
        }
      end

      subject do
        get '/searches', params: request_query_params
      end

      context 'with external API returning 400 status' do
        it 'renders a 400 status' do
          subject
          expect(response).to have_http_status(400)
        end

        it 'renders bad_request response' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to eq(expected_response)
        end
      end
    end

    context 'with sort_type passed without sort_by' do
      # TODO: Fix retry limit. "Random" values added instead.
      let(:brewery_1_name) { 'Free State Brewing Company' }
      let(:brewery_1_state) { 'kansas' }
      let(:brewery_2_name) { 'Boulevard Brewing Company' }
      let(:brewery_2_state) { 'colorado' }

      let(:request_query_params) { { sort_type: 'desc' } }

      let(:expected_response) do
        {
          'error' => {
            'body' => 'sort_by is missing!',
            'path' => '',
            'status' => 400
          }
        }
      end

      subject do
        get '/searches', params: request_query_params
      end

      context 'with external API returning 400 status' do
        it 'renders a 400 status' do
          subject
          expect(response).to have_http_status(400)
        end

        it 'renders bad_request response' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to eq(expected_response)
        end
      end
    end

    context 'with invalid sort_type' do
      # TODO: Fix retry limit. "Random" values added instead.
      let(:brewery_1_name) { 'Free State Brewing Company' }
      let(:brewery_1_state) { 'kansas' }
      let(:brewery_2_name) { 'Boulevard Brewing Company' }
      let(:brewery_2_state) { 'colorado' }

      let(:request_query_params) { { sort_by: 'name', sort_type: 'invalid sort type' } }

      let(:expected_response) do
        {
          'error' => {
            'body' => 'sort_type is invalid!',
            'path' => '',
            'status' => 400
          }
        }
      end

      subject do
        get '/searches', params: request_query_params
      end

      context 'with external API returning 400 status' do
        it 'renders a 400 status' do
          subject
          expect(response).to have_http_status(400)
        end

        it 'renders bad_request response' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to eq(expected_response)
        end
      end
    end

    context 'with invalid sort_by' do
      # TODO: Fix retry limit. "Random" values added instead.
      let(:brewery_1_name) { 'Free State Brewing Company' }
      let(:brewery_1_state) { 'kansas' }
      let(:brewery_2_name) { 'Boulevard Brewing Company' }
      let(:brewery_2_state) { 'colorado' }

      let(:request_query_params) { { sort_by: 'invalid sort by', sort_type: 'desc' } }

      let(:expected_response) do
        {
          'error' => {
            'body' => 'sort_by is invalid!',
            'path' => '',
            'status' => 400
          }
        }
      end

      subject do
        get '/searches', params: request_query_params
      end

      context 'with external API returning 400 status' do
        it 'renders a 400 status' do
          subject
          expect(response).to have_http_status(400)
        end

        it 'renders bad_request response' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to eq(expected_response)
        end
      end
    end

    context 'with service client error raised' do
      # TODO: Fix retry limit. "Random" values added instead.
      let(:brewery_1_name) { 'Free State Brewing Company' }
      let(:brewery_2_name) { 'Boulevard Brewing Company' }

      let(:request_query_params) { {} }

      subject do
        get '/searches', params: request_query_params
      end

      context 'with a Faraday exception raised from the service client' do
        let(:error_response) do
          {
            'error' => {
              'body' => 'Faraday failed!',
              'path' => "#{BREWERY_API_URL}#{endpoint_uri}",
              'status' => 500
            }
          }
        end
        before do
          allow(Faraday)
            .to receive(:new)
            .with(brewery_api_url, options)
            .and_raise(Faraday::Error.new('Faraday failed!'))
        end

        it 'renders a 500 status' do
          subject
          expect(response).to have_http_status(500)
        end

        it 'renders a exception JSON response' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to eq(error_response)
        end
      end

      shared_examples 'an error response status from the service client' do |status, error_status, body|
        let(:faraday_response) do
          double(
            Faraday::Response,
            status: status,
            body: body
          )
        end

        let(:error_response) do
          {
            'error' => {
              'body' => body,
              'path' => "#{BREWERY_API_URL}#{endpoint_uri}",
              'status' => error_status
            }
          }
        end

        it "renders a #{error_status} status" do
          subject
          expect(response).to have_http_status(error_status)
        end

        it 'renders a exception JSON response' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to eq(error_response)
        end
      end

      it_behaves_like 'an error response status from the service client',
                      400,
                      400,
                      'Error!'
      it_behaves_like 'an error response status from the service client',
                      401,
                      401,
                      'Error!'
      it_behaves_like 'an error response status from the service client',
                      403,
                      403,
                      'Error!'
      it_behaves_like 'an error response status from the service client',
                      404,
                      404,
                      'Resource Not Found!'
      it_behaves_like 'an error response status from the service client',
                      422,
                      422,
                      'Error!'
      it_behaves_like 'an error response status from the service client',
                      9999,
                      500,
                      'Error!'
    end
  end
end
