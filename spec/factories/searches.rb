# frozen_string_literal: true

FactoryBot.define do
  factory :search do
    state { Faker::Address.unique.state }
    brewery_type { 'brewpub' }
  end
end
