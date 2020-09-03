# frozen_string_literal: true

FactoryBot.define do
  factory :brewery do
    name { Faker::Beer.unique.brand }
    state { Faker::Address.unique.state }
    brewery_type { 'brewpub' }
  end
end
