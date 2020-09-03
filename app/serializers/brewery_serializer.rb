# frozen_string_literal: true

class BrewerySerializer < ActiveModel::Serializer
  attributes :state, :brewery_type, :name
end
