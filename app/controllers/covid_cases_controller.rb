# frozen_string_literal: true

class CovidCasesController < ApplicationController
  def index
    response = ServiceClients::CovidApiClient.retrieve_case_summary
    render status: :ok, json: response
  end
end
