# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  def render_error(code, msg)
    logger.fatal message: "status code: #{code}, error_message: #{msg}"
    render status: code, json: { error: msg }
  end

  def handle_bad_request_error(error)
    render_error :bad_request, error.message
  end

  def handle_unauthorized_error(error)
    render_error :unauthorized, error.message
  end

  def handle_forbidden_error(error)
    render_error :forbidden, error.message
  end

  def handle_resource_not_found_error(error)
    render_error :not_found, error.message
  end

  def handle_unprocessable_entity_error(error)
    render_error :conflict, error.message
  end

  def handle_bad_http_response_error(error)
    render_error :bad_request, error.message
  end

  def handle_service_error(error)
    render_error :internal_server_error, error.message
  end
end
