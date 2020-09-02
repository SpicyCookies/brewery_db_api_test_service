# frozen_string_literal: true

class TypeValidator < ActiveModel::Validator
  ACCEPTED_TYPES = ['micro', 'regional', 'brewpub', 'large', 'planning', 'bar', 'contract', 'proprietor']

  def validate(record)
    unless ACCEPTED_TYPES.include? record.brewery_type
      record.errors[:brewery_type] << 'Must contain an accepted brewery_type!'
    end
  end
end
