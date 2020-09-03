# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, type: :model do
  describe 'associations' do
    it { should have_many(:breweries).dependent(:destroy) }
  end

  describe 'validations' do
    context 'with uniqueness' do
      it { should validate_uniqueness_of(:state).scoped_to(:brewery_type).case_insensitive }
      it { should validate_uniqueness_of(:brewery_type).scoped_to(:state).case_insensitive }
    end
  end
end
