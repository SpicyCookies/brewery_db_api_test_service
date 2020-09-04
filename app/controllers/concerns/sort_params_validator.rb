# frozen_string_literal: true

# TODO: So much refactoring needed
# Validations for sort params
# Requires sort_params to be defined in the controller
module SortParamsValidator
  extend ActiveSupport::Concern

  SORT_NAMES = ['name']
  SORT_TYPES = ['asc', 'desc']

  # Raises BadRequestError if invalid
  def validate_sort_params
    # Checks if at least sort_by is defined in the permitted sort_params
    if sort_params[:sort_type].present? && sort_params[:sort_by].blank?
      message = 'sort_by is missing!'

      raise HotelEngineTestService::Errors::BadRequestError.new(
        400, '', message
      )
    end

    # Checks if sort_name is valid
    if SORT_NAMES.exclude?(sort_params[:sort_by]) && sort_params[:sort_by].present?
      message = 'sort_by is invalid!'

      raise HotelEngineTestService::Errors::BadRequestError.new(
        400, '', message
      )
    end

    # Checks if sort_type is valid
    if SORT_TYPES.exclude?(sort_params[:sort_type]) &&
        sort_params[:sort_by].present? &&
        sort_params[:sort_type].present?
      message = 'sort_type is invalid!'

      raise HotelEngineTestService::Errors::BadRequestError.new(
        400, '', message
      )
    end
  end
end
