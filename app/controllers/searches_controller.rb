# frozen_string_literal: true

class SearchesController < ApplicationController
  def index
    # Assumption: A nil and empty string are the same query for the Brewery API
    state_param = search_params[:state].blank? ? nil : search_params[:state]
    brewery_type_param = search_params[:brewery_type].blank? ? nil : search_params[:brewery_type]

    search_instance = Search.find_by(
      state: state_param,
      brewery_type: brewery_type_param
    )

    breweries = if search_instance
      search_instance.breweries
    else
      retrieved_breweries = Brewery.retrieve_breweries(
        state: search_params[:state],
        brewery_type: search_params[:brewery_type]
      )

      # Save breweries into new unique search
      Search.create!(
        state: search_params[:state],
        brewery_type: search_params[:brewery_type],
        breweries: retrieved_breweries
      )

      retrieved_breweries
    end

    render status: :ok, json: breweries.to_json
  end

  def delete_all_searches
    Search.delete_all
  end

  private

  def search_params
    params.permit(:state, :brewery_type)
  end
end
