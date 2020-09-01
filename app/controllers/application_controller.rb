# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ErrorHandler

  # HotelEngineTestService Error Handling
  rescue_from HotelEngineTestService::Errors::BadRequestError, with: :handle_bad_request_error
  rescue_from HotelEngineTestService::Errors::UnauthorizedRequestError, with: :handle_unauthorized_error
  rescue_from HotelEngineTestService::Errors::ForbiddenRequestError, with: :handle_forbidden_error
  rescue_from HotelEngineTestService::Errors::ResourceNotFoundError, with: :handle_resource_not_found_error
  rescue_from HotelEngineTestService::Errors::UnprocessableEntityError, with: :handle_unprocessable_entity_error
  rescue_from HotelEngineTestService::Errors::BadHttpResponseError, with: :handle_bad_http_response_error
  rescue_from HotelEngineTestService::Errors::ServiceError, with: :handle_service_error
end
