# frozen_string_literal: true

# Validations for sort params
# Requires sort_params to be defined in the controller
module SortParamsValidator
  extend ActiveSupport::Concern

  # Checks if at least sort_by is defined in the permitted sort_params
  # Raises BadRequestError if invalid
  def validate_sort_params
    if sort_params[:sort_type].present? && sort_params[:sort_by].blank?
      message = 'sort_by is missing!'

      raise HotelEngineTestService::Errors::BadRequestError.new(
        400, '', message
      )
    end
  end
end
