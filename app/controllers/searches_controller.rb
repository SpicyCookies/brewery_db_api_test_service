# frozen_string_literal: true

class SearchesController < ApplicationController
  # Observation: On an index without query params, the external API will only return a partial response.
  # Observation: The default results on the external API are 20 results.
  def index
    # Assumption: A nil and empty string are the same query for the Brewery API
    state_param = search_params[:state].blank? ? nil : search_params[:state]
    brewery_type_param = search_params[:brewery_type].blank? ? nil : search_params[:brewery_type]

    search_instance = Search.find_by(
      state: state_param,
      brewery_type: brewery_type_param
    )

    breweries = if search_instance
      # Returns Brewery::ActiveRecord_Associations_CollectionProxy
      search_instance.breweries
    else
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

    # Sorts breweries if sort_by param is passed
    result_breweries = sort_breweries(breweries)

    render status: :ok, json: result_breweries, each_serializer: BrewerySerializer
  end

  def delete_all_searches
    Search.delete_all
  end

  private

  def search_params
    params.permit(:state, :brewery_type)
  end

  def sort_params
    params.permit(:sort_by, :sort_type)
  end

  # Internal: Sorts a list of Breweries
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
end
