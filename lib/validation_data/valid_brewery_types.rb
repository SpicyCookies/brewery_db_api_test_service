# frozen_string_literal: true

module ValidationData
  class ValidBreweryTypes
    def self.all
      [
        'micro',
        'regional',
        'brewpub',
        'large',
        'planning',
        'bar',
        'contract',
        'proprietor'
      ]
    end
  end
end
