# frozen_string_literal: true

# TODO: Move this into a .yaml file and pass it through an initializer
# TODO: Add a .yaml for states
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
