# frozen_string_literal: true

class SearchesController < ApplicationController
  include SortParamsValidator

  # Param validations
  before_action :validate_brewery_type, only: [:index]
  before_action :validate_sort_params, only: [:index]

  # External API Notes:
  # Observation: On an index without query params, the external API will only return a partial response.
  # Observation: The default results on the external API are 20 results.

  # Public: Lists all breweries
  #
  # Renders JSON response
  def index
    # Assumption: A nil and empty string are the same query for the external Brewery API.
    # Since a nil and empty string are different for ActiveRecord objects,
    # convert all empty query params to nil.
    state_param = search_params[:state].presence&.downcase # The external API requires lowercase
    brewery_type_param = search_params[:brewery_type].presence

    # Query Search records for a duplicate Search record
    search_instance = Search.find_by(
      state: state_param,
      brewery_type: brewery_type_param
    )

    breweries = if search_instance
                  # Returns Brewery::ActiveRecord_Associations_CollectionProxy
                  search_instance.breweries
                else
                  # Retrieve breweries for new unique search
                  retrieved_breweries = Brewery.retrieve_breweries(
                    state: state_param,
                    brewery_type: brewery_type_param
                  )

                  # Save breweries into new unique search
                  search = Search.create!(
                    state: state_param,
                    brewery_type: brewery_type_param,
                    breweries: retrieved_breweries
                  )

                  # Returns Brewery::ActiveRecord_Associations_CollectionProxy
                  search.breweries
                end

    # Sorts breweries if at least the sort_by param is passed
    result_breweries = sort_breweries(breweries)

    render status: :ok, json: result_breweries, each_serializer: BrewerySerializer
  end

  # Public: Destroys all breweries
  #
  # Renders JSON response
  def delete_all_searches
    if Search.all.empty?
      message = {
        message: 'Search history is already empty.'
      }

      return render status: :ok, json: message.to_json
    end

    message = {
      message: 'Search history cleared.'
    }

    Search.destroy_all

    render status: :ok, json: message.to_json
  end

  private

  #
  # Helper methods
  #

  def search_params
    params.permit(:state, :brewery_type)
  end

  def sort_params
    params.permit(:sort_by, :sort_type)
  end

  # Internal: Sorts a list of Breweries
  #
  # breweries - Array of type Brewery::ActiveRecord_Associations_CollectionProxy.
  #
  # Returns sorted breweries if given valid sort_by param
  def sort_breweries(breweries)
    if sort_params[:sort_by] == 'name'
      if sort_params[:sort_type] == 'desc'
        breweries.sort_name_desc
      else
        breweries.sort_name_asc
      end
    else
      breweries
    end
  end

  #
  # SearchController specific validators
  #

  def validate_brewery_type
    return if search_params[:brewery_type].blank?

    if ValidationData::ValidBreweryTypes.all.exclude? search_params[:brewery_type]
      message = 'brewery_type is invalid!'

      raise HotelEngineTestService::Errors::BadRequestError.new(
        400, '', message
      )
    end
  end
end
