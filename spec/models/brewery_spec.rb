# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Brewery, type: :model do
  describe 'associations' do
    it { should belong_to(:search) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :state }
    it { should validate_presence_of :brewery_type }
  end
end
