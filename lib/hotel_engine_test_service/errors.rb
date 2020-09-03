# frozen_string_literal: true

module HotelEngineTestService
  module Errors
    class ServiceError < StandardError
      attr_reader :status, :path, :body

      def initialize(status, path, body)
        @status = status
        @path = path
        @body = body
      end

      def message
        {
          status: @status,
          path: @path,
          body: @body
        }
      end
    end

    class BadRequestError < ServiceError
    end

    class UnauthorizedRequestError < ServiceError
    end

    class ForbiddenRequestError < ServiceError
    end

    class ResourceNotFoundError < ServiceError
    end

    class UnprocessableEntityError < ServiceError
    end

    class BadHttpResponseError < ServiceError
    end
  end
end
