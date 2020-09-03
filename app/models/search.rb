# frozen_string_literal: true

class Search < ApplicationRecord
  include ActiveModel::Validations

  has_many :breweries, dependent: :destroy

  validates :state,
            uniqueness: {
              scope: :brewery_type,
              case_sensitive: false
            }
  validates :brewery_type,
            uniqueness: {
              scope: :state,
              case_sensitive: false
            }
end
